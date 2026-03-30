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