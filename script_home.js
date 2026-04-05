    function marcar_publico(){
        if(document.getElementById('checkbox_publica').checked == false){
            document.getElementById('checkbox_publica').checked = true;
            document.getElementById('checkbox_privado').checked = false;
        } else {
            document.getElementById('checkbox_publica').checked = false;
        }
    }

    function marcar_privado(){
        if(document.getElementById('checkbox_privado').checked == false){
            document.getElementById('checkbox_privado').checked = true;
            document.getElementById('checkbox_publica').checked = false;
        } else {
            document.getElementById('checkbox_privado').checked = false;
        }
    }

    function simular(){
        let doses = Number(id_doses.value);
        let doses_perdidas = Number(id_doses_perdidas.value);
        let doses_por_lote = Number(id_doses_por_lote.value);
        let valor_vacina = Number(id_valor_unitario.value);
        
        let porcentagem_perdida = (doses_perdidas / doses) * 100
        let valor_total = doses * valor_vacina
        let qtd_lotes = doses / doses_por_lote
        let valor_lote = valor_vacina * qtd_lotes
        console.log(porcentagem_perdida);

        porcentagem.innerHTML = `${porcentagem_perdida.toFixed(2)}%`
        receita_alcancada.innerHTML = `De ${valor_total.toFixed(2)} R$, foi alcançado ${(valor_total - (doses_perdidas * valor_vacina)).toFixed(2)} R$`
        receita_perdida.innerHTML = `${(doses_perdidas * valor_vacina).toFixed(2)} R$`
        lotes_perdidos.innerHTML = `De ${(qtd_lotes).toFixed(0)} lotes, <span style="color: red; margin-right: 10px; margin-left: 10px"> ${(doses_perdidas / doses_por_lote).toFixed(0)} </span> são perdidos`
    }