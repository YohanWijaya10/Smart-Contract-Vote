// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public pemilik;
    bool public StatusTerbuka = true;

    struct kandidat{
        string nama;
        uint suara;
    }

    kandidat[] public KandidatList;

    mapping(address => bool ) public sudahMemilih;

    modifier hanyaPemilik() {
        require(msg.sender == pemilik, "hanya Pemilik Contract Yang Bisa Mengubah");
        _;
    } 

    constructor(){
        pemilik = msg.sender;
    } 
    event kandidatDitambahkan(string nama);
    event suaraDitambahkan(address pemilih, string kandidat);
    event votingDitutup();


    function tamabahKandidat(string memory _nama) public hanyaPemilik {
        KandidatList.push(kandidat(_nama, 0));
        emit kandidatDitambahkan(_nama);

    }

    function memberikanSuara(uint _kandidatIndex) public{
        require(StatusTerbuka, "Pemilihan sudah tertutup" );
        require(!sudahMemilih[msg.sender], "kamu sudah Memilih");
        KandidatList[_kandidatIndex].suara += 1 ;
        sudahMemilih[msg.sender] = true;
        emit  suaraDitambahkan(msg.sender, KandidatList[_kandidatIndex].nama);
    }

    function tutupVoting() public hanyaPemilik{
        require(StatusTerbuka, "Voting Sudah Ditutup Sebelumnya");
        StatusTerbuka = false;
        emit votingDitutup();
    }

    function umumkanNamaPemenang() public view returns (string memory) {
        require(!StatusTerbuka, "Voting Sedang Berlangsung");
        uint suaraTertinggi = 0;
        string memory pemenang;

        for (uint i = 0; i < KandidatList.length; i++ ){
            if (KandidatList[i].suara > suaraTertinggi){
                suaraTertinggi = KandidatList[i].suara;
                pemenang = KandidatList[i].nama;
                
            }
        }
        
        return pemenang;
        
    } 


    function getTotalCandidate() public view returns (uint){
       return KandidatList.length;
    }

    function getCandidate(uint _candidateIndex) public view returns (string memory name, uint suara) {
        kandidat memory person = KandidatList[_candidateIndex];
        return (person.nama, person.suara);
    }


}