    function entrar(){
        let email = ipt_email.value
        let senha = ipt_senha.value

        verificarLogin(email, senha)
    }
    // 1. Seu "dicionário" de usuários (Logins e Senhas)
let bancoDeDados = {
  "enzoquinalha@gmail.com": "enzo123",
  "carloschaves@gmail.com": "carlos123",
  "matheusjacob@yahoo.com": "jacob123"
};

// 3. Função para validar o acesso
function verificarLogin(usuario, senha) {

  // Verifica se a chave (login) existe no objeto
  if (bancoDeDados.hasOwnProperty(usuario)) {
    
    // Se existir, verifica se a senha associada a essa chave é a correta
    if (bancoDeDados[usuario] === senha) {
      div_resultado.innerHTML = "Acesso concedido! Bem-vindo."
      return true;
    } else {
      div_resultado.innerHTML = "Senha incorreta."
      return false;
    }
    
  } else {
    div_resultado.innerHTML = "Usuário não encontrado."
    return false;
  }
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