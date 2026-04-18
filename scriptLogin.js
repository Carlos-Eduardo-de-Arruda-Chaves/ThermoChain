
let tentativas = 0;
let bloqueado = false;

function entrar(){
    // Impede a execução se o usuário estiver no tempo de bloqueio
    if (bloqueado) return;

    let email = ipt_email.value
    let senha = ipt_senha.value

    verificarLogin(email, senha)
}

// 1. Seu "dicionário" de usuários (Logins e Senhas)
let bancoDeDados = {
  "enzoquinalha@gmail.com": "enzo123",
  "carloschaves@gmail.com": "carlos123",
  "matheusjacob@yahoo.com": "jacob123",
  "leonardowerner@gmail.com":"leonardo123",
  "guilhermebarbosa@gmail.com":"guilherme123",
  "thiagoemidio@gmail.com":"thiago123",
};

// 3. Função para validar o acesso
function verificarLogin(usuario, senha) {
  // Impede a validação se o usuário estiver bloqueado
  if (bloqueado) return;

  div_emailErro.innerHTML = ``
  div_senhaErro.innerHTML = ``

  // Verifica se a chave (login) existe no objeto
  if (bancoDeDados.hasOwnProperty(usuario)) {
    
    // Se existir, verifica se a senha associada a essa chave é a correta
    if (bancoDeDados[usuario] === senha) {
      console.log("Acesso concedido! Bem-vindo.")
      tentativas = 0; // Reseta tentativas em caso de sucesso
      return true;
    } else {
      console.log("Senha incorreta.")
      div_senhaErro.innerHTML = `Senha Incorreta`
      
      // Lógica de contagem de erros adicionada:
      tentativas++;
      if (tentativas >= 3) {
          bloquearUsuario();
      }
      return false;
    }
    
  } else {
    console.log("Usuário não encontrado.")
    div_emailErro.innerHTML = `Usuário não encontrado`
  }

}

// função para bloquear o usuario e desbloquear após 30 seg
function bloquearUsuario() {
    bloqueado = true;
    div_senhaErro.innerHTML = `Muitas tentativas! Bloqueado por 30 segundos.`;
    
    // Desativa o botão se o ID for btn_entrar
    if(typeof btn_entrar !== 'undefined') btn_entrar.disabled = true;

    setTimeout(() => {
        bloqueado = false;
        tentativas = 0;
        if(typeof btn_entrar !== 'undefined') btn_entrar.disabled = false;
        div_senhaErro.innerHTML = `Acesso liberado. Tente novamente.`;
    }, 30000); 
}

olho.addEventListener('mousedown', function() {
  ipt_senha.type = 'text';
});
olho.addEventListener('mouseup', function() {
  ipt_senha.type = 'password';
});
olho.addEventListener('mousemove', function() {
  ipt_senha.type = 'password';
});