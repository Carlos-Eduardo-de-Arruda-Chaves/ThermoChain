// Função para mostrar ou esconder a senha
function mostrarSenha(idInput) {

    // Pega o input pelo ID recebido
    const input =
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
    const inputUsuario =
        document.getElementById("input_usuario");

    const inputEmail =
        document.getElementById("input_email");

    const inputSenha =
        document.getElementById("input_senha");

    const inputConfSenha =
        document.getElementById("input_confsenha");


    // PEGANDO OS VALORES

    // Pega o valor digitado
    // e remove espaços extras
    const usuario =
        inputUsuario.value.trim();

    const email =
        inputEmail.value.trim();

    const senha =
        inputSenha.value.trim();

    const confSenha =
        inputConfSenha.value.trim();


    // DIVS DE ERRO

    // Captura os locais onde os erros
    // vão aparecer na tela
    const divUsuarioErro =
        document.getElementById("div_usuarioErro");

    const divEmailErro =
        document.getElementById("div_emailErro");

    const divSenhaErro =
        document.getElementById("div_senhaErro");

    const divConfSenhaErro =
        document.getElementById("div_confSenhaErro");

    const alerta =
        document.getElementById("alerta");


    // LIMPAR ERROS ANTIGOS

    // Limpa mensagens antigas
    // antes de validar novamente
    divUsuarioErro.innerHTML = "";
    divEmailErro.innerHTML = "";
    divSenhaErro.innerHTML = "";
    divConfSenhaErro.innerHTML = "";

    alerta.innerHTML = "";



    // VALIDAR CAMPOS VAZIOS

    // Verifica se algum campo ficou vazio
    if (
        usuario == "" ||
        email == "" ||
        senha == "" ||
        confSenha == ""
    ) {

        alerta.innerHTML =
            "Preencha todos os campos.";

        // Para a execução da função
        return;
    }


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


    // =========================
    // ENVIO PARA O BACKEND
    // =========================

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
            senhaServer: senha

        })

    })

    // RESPOSTA DO SERVIDOR
    .then(function (resposta) {

        // Se o cadastro der certo
        if (resposta.ok) {

            alerta.innerHTML =
                "✅ Cadastro realizado com sucesso!";


            // Limpa os campos
            inputUsuario.value = "";
            inputEmail.value = "";
            inputSenha.value = "";
            inputConfSenha.value = "";


            // Aguarda 2 segundos
            // e redireciona para login
            setTimeout(function () {

                window.location =
                    "../HTML/login.html";

            }, 2000);

        } else {

            // Caso dê erro no cadastro
            alerta.innerHTML =
                "❌ Erro ao realizar cadastro.";

        }

    })



    // ERRO DO SISTEMA

    .catch(function (erro) {

        // Mostra erro no console
        console.log(erro);

        // Mostra erro visual
        alerta.innerHTML =
            "❌ Erro interno do sistema.";

    });

}