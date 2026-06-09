
//  CONTROLE DE TENTATIVAS

// Quantidade de tentativas erradas
let tentativas = 0;

// Controla se o usuário está bloqueado
let bloqueado = false;





// "BANCO DE DADOS" MOKADO

// Objeto simulando usuários cadastrados
// chave = email
// valor = senha

// VALIDAÇÃO DE LOGIN

function verificarLogin(usuario, senha) {

    // Impede tentativa se estiver bloqueado
    if (bloqueado) return;

    // Limpa mensagens antigas
    div_emailErro.innerHTML = ``
    div_senhaErro.innerHTML = ``


    // Verifica se o usuário existe no objeto
    if (bancoDeDados.hasOwnProperty(usuario)) {


        // Se existir, verifica se a senha está correta
        if (bancoDeDados[usuario] === senha) {

            console.log("Acesso concedido! Bem-vindo.")

            // Reseta tentativas após login correto
            tentativas = 0;

            return true;

        } else {

            // Senha incorreta
            console.log("Senha incorreta.")

            div_senhaErro.innerHTML =
                `Senha Incorreta`


            // Soma tentativa errada
            tentativas++;


            // Se atingir 3 erros
            // bloqueia usuário
            if (tentativas >= 3) {

                bloquearUsuario();

            }

            return false;
        }


    } else {

        // Usuário não encontrado
        console.log("Usuário não encontrado.")

        div_emailErro.innerHTML =
            `Usuário não encontrado`

    }

}


// BLOQUEIO TEMPORÁRIO

// Bloqueia login por 30 segundos
function bloquearUsuario() {

    // Ativa bloqueio
    bloqueado = true;

    div_senhaErro.innerHTML =
        `Muitas tentativas! Bloqueado por 30 segundos.`;


    // Desativa botão de login
    if (typeof btn_entrar !== 'undefined')

        btn_entrar.disabled = true;


    // Espera 30 segundos
    setTimeout(() => {

        // Libera acesso novamente
        bloqueado = false;

        // Zera tentativas
        tentativas = 0;

        // Reativa botão
        if (typeof btn_entrar !== 'undefined')

            btn_entrar.disabled = false;


        div_senhaErro.innerHTML =
            `Acesso liberado. Tente novamente.`;

    }, 30000);

}


// MOSTRAR SENHA

// Enquanto segura o mouse,
// mostra senha
olho.addEventListener('mousedown', function () {

    ipt_senha.type = 'text';

});


// Quando solta,
// esconde senha
olho.addEventListener('mouseup', function () {

    ipt_senha.type = 'password';

});


// Se mover mouse para fora,
// também esconde
olho.addEventListener('mousemove', function () {

    ipt_senha.type = 'password';

});


// LOGIN COM BACKEND

function entrar() {




    // INPUTS

    // Captura campos do HTML
    const emailInput = document.getElementById("ipt_email");
    const senhaInput = document.getElementById("ipt_senha");
    const codigoEmpresaInput = document.getElementById("ipt_codigoEmpresa");


    // VALORES

    // Pega os valores digitados
    const emailVar = emailInput.value.trim();
    const senhaVar = senhaInput.value.trim();
    const codigoEmpresaVar = codigoEmpresaInput.value.trim();



    // ELEMENTOS DE ERRO

    // Caixa de erro
    const cardErro =
        document.getElementById("cardErro");

    // Texto do erro
    const mensagemErro =
        document.getElementById("mensagem_erro");



    // LIMPAR ERROS ANTIGOS

    mensagemErro.innerHTML = "";

    cardErro.style.display = "none";



    // CAMPOS VAZIOS

    // Verifica se algum campo ficou vazio
    if (
        emailVar == "" ||
        senhaVar == "" ||
        codigoEmpresaVar == ""
    ) {

        // Mostra erro
        cardErro.style.display = "block";

        mensagemErro.innerHTML =
            "Preencha todos os campos.";



        // Esconde mensagem após 5 segundos
        setTimeout(sumirMensagem, 5000);

        return false;
    }



    // VALIDAR EMAIL

    // Verifica formato básico do email
    if (
        !emailVar.includes("@") ||
        !emailVar.includes(".")
    ) {

        cardErro.style.display = "block";

        mensagemErro.innerHTML =
            "E-mail inválido.";



        setTimeout(sumirMensagem, 5000);

        return false;
    }


    // Debug no console
    console.log("FORM LOGIN:", emailVar);



    // REQUISIÇÃO AO BACKEND

    // estranhasso 

    fetch("/usuarios/autenticar", {

        // Método HTTP
        method: "POST",

        // Tipo de envio
        headers: {
            "Content-Type": "application/json"
        },


        // Dados enviados
        body: JSON.stringify({

            emailServer: emailVar,
            senhaServer: senhaVar,
            codigoEmpresaServer: codigoEmpresaVar
        })

    })



        // RESPOSTA DO SERVIDOR

        .then(function (resposta) {

            console.log(
                "ESTOU NO THEN DO entrar()!"
            );


            // Login correto
            if (resposta.ok) {

                resposta.json().then(json => {

                    console.log(json);



                    // SESSION STORAGE


                    // Salva dados do usuário
                    sessionStorage.EMAIL_USUARIO =
                        json.email;

                    sessionStorage.NOME_USUARIO =
                        json.nome;

                    sessionStorage.ID_USUARIO =
                        json.id;

                    sessionStorage.FK_EMPRESA =
                        json.fkEmpresa




                    // REDIRECIONAMENTO


                    if (json.n3 == 0) {
                        setTimeout(function () {
                            window.location = "Tela_home.html";
                        }, 1000); // 1000ms = 1 segundo 
                    } else if (json.n3 == 1) {
                        setTimeout(function () {
                            window.location = "../HTML/central_servico.html";
                        }, 1000); // 1000ms = 1 segundo 
                    }

                });


            } else {

                // Login inválido
                resposta.text().then(texto => {

                    console.error(texto);

                    cardErro.style.display =
                        "block";

                    mensagemErro.innerHTML =
                        "Email ou senha inválidos.";



                    setTimeout(
                        sumirMensagem,
                        5000
                    );

                });

            }

        })



        // ERRO DO SISTEMA
        .catch(function (erro) {

            console.log(erro);

            cardErro.style.display =
                "block";

            mensagemErro.innerHTML =
                "Erro interno do servidor.";


            setTimeout(sumirMensagem, 5000);

        });

    return false;
}



// ESCONDER ALERTA
function sumirMensagem() {

    // Pega caixa de erro
    const cardErro =
        document.getElementById("cardErro");

    // Esconde alerta
    cardErro.style.display = "none";
}