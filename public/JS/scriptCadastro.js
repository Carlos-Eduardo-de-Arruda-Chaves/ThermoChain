// Função para mostrar ou esconder a senha
function mostrarSenha(idInput) {

    // Pega o input pelo ID recebido
    let input =
        document.getElementById(idInput);

    // Se o input estiver como password,
    // troca para text para mostrar a senha
    if (input.type === "password") {

        input.type = "text";

    } else {

        // Se já estiver visível,
        // volta para password
        input.type = "password";

    }
}


// Função principal do cadastro
function cadastrar() {


    // PEGANDO OS INPUTS

    // Captura os campos do HTML

    let inputUsuario =
        document.getElementById("input_usuario");

    let inputEmail =
        document.getElementById("input_email");

    let inputSenha =
        document.getElementById("input_senha");
    let input_cpf =
        document.getElementById("input_cpf");
    let inputConfSenha =
        document.getElementById("input_confsenha");
    let inputEmpresa = document.getElementById("input_empresa");

    // PEGANDO OS VALORES

    // Pega o valor digitado
    // e remove espaços extras
    let usuario =
        inputUsuario.value.trim();

    let email =
        inputEmail.value.trim();

    let senha =
        inputSenha.value.trim();

    let confSenha =
        inputConfSenha.value.trim();

    let cpf =
        input_cpf.value.trim();

    let codigoEmpresaTexto = inputEmpresa.value.trim();
    // DIVS DE ERRO

    // Captura os locais onde os erros
    // vão aparecer na tela
    let divUsuarioErro =
        document.getElementById("div_usuarioErro");

    let divEmailErro =
        document.getElementById("div_emailErro");

    let divSenhaErro =
        document.getElementById("div_senhaErro");
    let divEmpresaErro = document.getElementById("div_empresaErro");
    let divConfSenhaErro =
        document.getElementById("div_confSenhaErro");
    let divCpf =
        document.getElementById("div_cpfErro");
    let alerta =
        document.getElementById("alerta");

    console.log(divUsuarioErro);
    console.log(divEmailErro);
    console.log(divSenhaErro);
    console.log(divConfSenhaErro);
    console.log(divEmpresaErro);
    console.log(divCpf);
    console.log(alerta);
    // LIMPAR ERROS ANTIGOS

    // Limpa mensagens antigas
    // antes de validar novamente
    divUsuarioErro.innerHTML = "";
    divEmailErro.innerHTML = "";
    divSenhaErro.innerHTML = "";
    divConfSenhaErro.innerHTML = "";
    divEmpresaErro.innerHTML = "";
    divCpf.innerHTML = "";
    alerta.innerHTML = "";



    // VALIDAR CAMPOS VAZIOS

    // Verifica se algum campo ficou vazio
    if (
        usuario == "" ||
        email == "" ||
        senha == "" ||
        confSenha == "" ||
        cpf == ""
    ) {

        alerta.innerHTML =
            "Preencha todos os campos.";

        // Para a execução da função
        return;
    }
    // confirmar se o codigo de empresa está vazio


    // VALIDAR EMAIL

    // Verifica se o email possui
    // @ e ponto
    if (
        !email.includes("@") ||
        !email.includes(".")
    ) {

        divEmailErro.innerHTML =
            "E-mail inválido.";

        return;
    }


    // VALIDAR SENHA


    // Verifica se a senha possui
    // pelo menos 8 caracteres
    if (senha.length < 8) {

        divSenhaErro.innerHTML =
            "A senha deve ter no mínimo 8 caracteres.";

        return;
    }


    // CONFIRMAR SENHA

    // Verifica se as duas senhas
    // são iguais
    if (senha != confSenha) {

        divConfSenhaErro.innerHTML =
            "As senhas não coincidem.";

        return;
    }

    // Verifica se o cpf do usuario possui mais dígitos ou menos
    if (cpf.length == 11) {
        divCpf.innerHTML = "CPF VÁLIDO";
    } else {
        divCpf.innerHTML = "CPF INVÁLIDO";
        return;
    }
    // ENVIO PARA O BACKEND


    // Envia os dados para a rota
    // de cadastro do servidor
    fetch("/usuarios/cadastrar", {

        // Método HTTP
        method: "POST",

        // Tipo de conteúdo enviado
        headers: {
            "Content-Type": "application/json"
        },

        // Dados enviados para o backend
        body: JSON.stringify({

            nomeServer: usuario,
            emailServer: email,
            senhaServer: senha,
            cpfServer: cpf,
            fkEmpresaServer: codigoEmpresaTexto
        })

    })

        // RESPOSTA DO SERVIDOR
        .then(function (resposta) {

            // Se o cadastro der certo
            if (resposta.ok) {

                alerta.innerHTML =
                    "Cadastro realizado com sucesso!";


                // Limpa os campos
                inputUsuario.value = "";
                inputEmail.value = "";
                inputSenha.value = "";
                inputConfSenha.value = "";
                input_cpf.value = "";
                inputEmpresa.value = "";
                // Aguarda 2 segundos
                // e redireciona para login
                setTimeout(function () {

                    window.location =
                        "../HTML/login.html";

                }, 2000);

            } else {

                // Caso dê erro no cadastro
                alerta.innerHTML =
                    " Erro ao realizar cadastro.";

            }

        })



        // ERRO DO SISTEMA

        .catch(function (erro) {

            // Mostra erro no console
            console.log(erro);

            // Mostra erro visual
            alerta.innerHTML =
                "Erro interno do sistema.";

        });

}