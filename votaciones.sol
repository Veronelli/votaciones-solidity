//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract Votaciones{
    address owner;

    constructor () public {
        owner = msg.sender;
    }

    mapping(string => bytes32) idCandidato;
    mapping(string => uint) votosCandidato;

    string [] public candidatos;

    bytes32[] votantes;

    bool flag = false;

    modifier candidatoValido(string memory _candidato) {
        bytes32 candidato = keccak256(abi.encodePacked(_candidato));
        bool existe = false;
        for (uint i = 0; i < candidatos.length; i++){
            if(candidato == keccak256(abi.encodePacked(candidatos[i]))){
                existe == true;
            }
        }
        require(existe != true);
        _;
    }

    modifier enVotacion(){
        require(flag == false,"Votacion Finalizada");
        _;
    }

    function representar(string memory _nombrePersona,uint _edad,string memory _idPersona ) enVotacion public{
        //Hash de los datos del candidato
        bytes32 candidato = keccak256(abi.encodePacked(_nombrePersona,_edad,_idPersona));

        idCandidato[_nombrePersona] =  candidato;
        candidatos.push(_nombrePersona);

    }

    function verCandidatos()public view returns (string[] memory){
        return candidatos;
    }

    function votarCandidato(string memory _nombreCandidato) public enVotacion candidatoValido(_nombreCandidato) {
        bytes32 votante = keccak256(abi.encodePacked(msg.sender));
        bytes32 nombreCandidato = keccak256(abi.encodePacked(_nombreCandidato));
        bool encontrado = false;

        for(uint i = 0; i < votantes.length; i++){
                require(votante != votantes[i],"Ya no puedes votar");
            }
        votosCandidato[_nombreCandidato]++; 
        votantes.push(votante);
        }

    function verVotos(string memory _candidato) public view candidatoValido(_candidato)  returns (uint){
        return votosCandidato[_candidato];
    }

    function uint2str(uint256 _i) internal pure returns (string memory str){
        if (_i == 0){
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0){
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

    function verResultado() public view returns(string memory){
        string memory resultado="";
        for(uint i = 0; i < votantes.length; i++){
            resultado = string(abi.encodePacked(resultado, "(",candidatos[i], ", ", uint2str(verVotos(candidatos[i])),") -----"));
        }
        return resultado;
    }

    function verGanador()public view  returns(string memory){
        string memory ganador = candidatos[0];
        for ( uint i = 0; i < candidatos.length; i++ ){
            string memory nombreCandidato = candidatos[i];
            if(votosCandidato[ganador] < votosCandidato[nombreCandidato]){
                ganador = nombreCandidato;
            }
        }
        return ganador;

    }

    function finalizarVotacion() enVotacion public {
        flag = true;
    }
}