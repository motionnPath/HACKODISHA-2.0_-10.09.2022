// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;

// custom errors 
error PatientPass_NotOwner();
error PatientPass_NotKlinik();
error PatientPass_NotEnoughFee();
error PatientPass_TransactionFailed();
error PatientPass_NotPatient();

contract PatientPass {


    //events
    event newPatient(patient indexed newPatient);
    //constructor variable
    address public  s_owner;
    
    // 
    uint256 private constant s_subscriptioFee = 20;
    mapping(address => string) public klinikAddressToName;
    mapping(address => bool) private isKlinik; // is it a klinit?
    mapping(address => bool) private isPatient; // is it a patient?
    mapping(address => patient) private addressToPatient;
    mapping(address => patientRecord[]) private addressToPatientRecord;
    mapping(address => record) private addrToRecord;
    mapping(address => uint256) private addrTobalance; // patient 
    mapping(address => uint256) private currentKlinikToAmount; // balance of a specific klinik
    
    
    

    //helpers
    address public currentKlinik;
  

    // types declaration 
    
    struct patientRecord{
        
        record record;
    }
    struct patient { 
        string name;
        uint8 age;
        string addr;   
    }
    struct record{
        string traitement;
        string perscription;
        uint256 cost;
    }
    struct finalRecord{
        patient client;
        patientRecord[] Record;
    }


    constructor(){
        s_owner = msg.sender;
    }
    receive() external payable {}
    fallback() external payable {}
    
    function addKlinik(address klinikAddress, string memory klinikName) public onlyOwner{

        klinikAddressToName[klinikAddress] = klinikName;
        isKlinik[klinikAddress] = true;
        
        
    } 

    function subscribeAsPatient(string memory _name, uint8 _age, string memory _addr) public payable{
        // checks if enough fees paid for the sub
        if(msg.value < s_subscriptioFee){revert PatientPass_NotEnoughFee();}
        addressToPatient[msg.sender] = patient(_name,_age,_addr);
        isPatient[msg.sender] = true;
        emit newPatient(patient(_name,_age,_addr));
    }

    function addPatientRecord(address _addr,address _klinikaddr, string memory _traitement, string memory _prescription, uint256 _costs) public onlyKlinik{

        addrToRecord[_addr] =record(_traitement,_prescription,_costs);
        addressToPatientRecord[_addr].push(patientRecord(addrToRecord[_addr]));    
        addrTobalance[_addr] += _costs;
        currentKlinikToAmount[_klinikaddr] += _costs;
        
    }

    function fund(address _addr) public payable {

        require(msg.value >= addrTobalance[_addr]);
        addrTobalance[_addr] = 0;
       

      
    }
    function withDraw(address payable _addr) public payable onlyKlinik{

        _addr.transfer(currentKlinikToAmount[_addr]);
        currentKlinikToAmount[_addr]=0;
        /*(bool success, ) = _addr.call{value: currentKlinikToAmount[_addr]}("");
        if(success){currentKlinikToAmount[_addr]=0;}
        else{revert PatientPass_TransactionFailed();}
        */

    }
    
    function getFinalRecord(address  _addr) public view returns(finalRecord memory){
        return finalRecord(addressToPatient[_addr],addressToPatientRecord[_addr]);
    }

    function getPatient(address _addr) public view onlyKlinik returns(patient memory){
        return addressToPatient[_addr];
    }


    function getPatientDept(address _addr)public view returns(uint256){
        return addrTobalance[_addr];
    }

    function getKlinikBalance(address _addr)public view returns(uint256){
        return currentKlinikToAmount[_addr];
    }

    function getGlobalNetworth() public view returns(uint256){
        return address(this).balance;
    }
    function getOwner() public view returns(address){
        return s_owner;
    }



    modifier onlyOwner () {
        if(msg.sender != s_owner) revert PatientPass_NotOwner();
        _;
    }
    modifier onlyKlinik (){
        if(!isKlinik[msg.sender]) revert PatientPass_NotKlinik();
        _;
    }
    /*modifier onlyPatient(){
        if(!isPatient[msg.sender])revert PatientPass_NotPatient();
        _;
    }*/


       
}