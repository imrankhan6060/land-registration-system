// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Land {
    struct Landreg {
        uint id;
        uint area;
        string city;
        string state;
        uint landPrice;
        uint propertyPID;

    }

    struct Buyer{
        address id;
        string name;
        uint age;
        string city;
        uint CNIC;
        string email;
    }

    struct Seller{
        address id;
        string name;
        string city;
        uint age;
        uint CNIC;
       string email;
    }

    struct LandInspector {
        uint id;
        string name;
        uint age;
        string designation;
    }

    struct LandRequest{
        uint reqId;
        address sellerId;
        address buyerId;
        uint landId;
        // bool requestStatus;
        // bool requested;
    }

    //key value pairs
    mapping(uint => Landreg) public lands;
    mapping(uint => LandInspector) public InspectorMapping;
    mapping(address => Seller) public SellerMapping;
    mapping(address => Buyer) public BuyerMapping;
    mapping(uint => LandRequest) public RequestsMapping;

    mapping(address => bool) public RegisteredAddressMapping;
    mapping(address => bool) public RegisteredSellerMapping;
    mapping(address => bool) public RegisteredBuyerMapping;
    mapping(address => bool) public SellerVerification;
    mapping(address => bool) public SellerRejection;
    mapping(address => bool) public BuyerVerification;
    mapping(address => bool) public BuyerRejection;
    mapping(uint => bool) public LandVerification;
    mapping(uint => address) public LandOwner;
    mapping(uint => bool) public RequestStatus;
    mapping(uint => bool) public RequestedLands;
    mapping(uint => bool) public PaymentReceived;

    address public Land_Inspector;
    address[] public sellers;
    address[] public buyers;

    uint internal landsCount;
    uint internal inspectorsCount;
    uint internal sellersCount;
    uint internal buyersCount;
    uint internal requestsCount;

    event Registration(address _registrationId);
    event AddingLand(uint _landId);
    event Landrequested(address _sellerId);
    event requestApproved(address _buyerId);
    event Verified(address _id);
    event Rejected(address _id);

    constructor() {
        Land_Inspector = msg.sender ;
        addLandInspector("Inspector 1", 25, "Manager");
    }

    function addLandInspector(string memory _name, uint _age, string memory _designation) private {
        inspectorsCount++;
        InspectorMapping[inspectorsCount] = LandInspector(inspectorsCount, _name, _age, _designation);
    }

    function getLandsCount() public view returns (uint) {
        return landsCount;
    }

    function getBuyersCount() public view returns (uint) {
        return buyersCount;
    }

    function getSellersCount() public view returns (uint) {
        return sellersCount;
    }

    function getRequestsCount() public view returns (uint) {
        return requestsCount;
    }
    function getArea(uint i) public view returns (uint) {
        return lands[i].area;
    }
    function getCity(uint i) public view returns (string memory) {
        return lands[i].city;
    }
     function getState(uint i) public view returns (string memory) {
        return lands[i].state;
    }
    // function getStatus(uint i) public view returns (bool) {
    //     return lands[i].verificationStatus;
    // }
    function getPrice(uint i) public view returns (uint) {
        return lands[i].landPrice;
    }
    function getPID(uint i) public view returns (uint) {
        return lands[i].propertyPID;
    }
    
    
    function getLandOwner(uint id) public view returns (address) {
        return LandOwner[id];
    }

    function verifySeller(address _sellerId) public{
        require(isLandInspector(msg.sender));

        SellerVerification[_sellerId] = true;
        emit Verified(_sellerId);
    }

    function rejectSeller(address _sellerId) public{
        require(isLandInspector(msg.sender));

        SellerRejection[_sellerId] = true;
        emit Rejected(_sellerId);
    }

    function verifyBuyer(address _buyerId) public{
        require(isLandInspector(msg.sender));

        BuyerVerification[_buyerId] = true;
        emit Verified(_buyerId);
    }

    function rejectBuyer(address _buyerId) public{
        require(isLandInspector(msg.sender));

        BuyerRejection[_buyerId] = true;
        emit Rejected(_buyerId);
    }
    
    function verifyLand(uint _landId) public{
        require(isLandInspector(msg.sender));

        LandVerification[_landId] = true;
    }

    function isLandVerified(uint _id) public view returns (string memory) {
        if(LandVerification[_id]){
            return "true";
        }
    }

    function isVerified(address _id) public view returns (bool) {
        if(SellerVerification[_id] || BuyerVerification[_id]){
            return true;
        }
    }

    function isRejected(address _id) public view returns (bool) {
        if(SellerRejection[_id] || BuyerRejection[_id]){
            return true;
        }
    }

    function isSeller(address _id) public view returns (bool) {
        if(RegisteredSellerMapping[_id]){
            return true;
        }
    }

    function isLandInspector(address _id) public view returns (bool) {
        if(Land_Inspector == _id){
            return true;
        }else{
            return false;
        }
    }

    function isBuyer(address _id) public view returns (bool) {
        if(RegisteredBuyerMapping[_id]){
            return true;
        }
    }
    function isRegistered(address _id) public view returns (bool) {
        if(RegisteredAddressMapping[_id]){
            return true;
        }
    }

    function addLand(uint _area, string memory _city,string memory _state, uint landPrice, uint _propertyPID) public {
        require((isSeller(msg.sender)) && (isVerified(msg.sender)));
        landsCount++;
        lands[landsCount] = Landreg(landsCount, _area, _city, _state, landPrice,_propertyPID);
        LandOwner[landsCount] = msg.sender;
      
    }

 
    function registerSeller(string memory _name, uint _age, string memory _city, uint _CNIC , string memory _email) public {

        require(!RegisteredAddressMapping[msg.sender]);

        RegisteredAddressMapping[msg.sender] = true;
        RegisteredSellerMapping[msg.sender] = true ;
        sellersCount++;
        SellerMapping[msg.sender] = Seller(msg.sender, _name, _city, _age ,_CNIC, _email);
        sellers.push(msg.sender);
        emit Registration(msg.sender);
    }

    function updateSeller(string memory _name, uint _age, string memory _city, uint _CNIC , string memory _email) public {
   
        require(RegisteredAddressMapping[msg.sender] && (SellerMapping[msg.sender].id == msg.sender));

        SellerMapping[msg.sender].name = _name;
        SellerMapping[msg.sender].age = _age;
        SellerMapping[msg.sender].city = _city;
        SellerMapping[msg.sender].CNIC = _CNIC;
        SellerMapping[msg.sender].email = _email;

    }

    function getSeller() public view returns( address [] memory ){
        return(sellers);
    }


    function getSellerDetails(address i) public view returns (string memory, uint, uint, string memory) {
        return (SellerMapping[i].name, SellerMapping[i].age, SellerMapping[i].CNIC, SellerMapping[i].email);
    }
    
    function registerBuyer(string memory _name, uint _age, string memory _city, uint _CNIC , string memory _email) public {
      
        require(!RegisteredAddressMapping[msg.sender]);

        RegisteredAddressMapping[msg.sender] = true;
        RegisteredBuyerMapping[msg.sender] = true ;
        buyersCount++;
        BuyerMapping[msg.sender] = Buyer(msg.sender, _name, _age, _city, _CNIC, _email);
        buyers.push(msg.sender);

        emit Registration(msg.sender);
    }

    function updateBuyer(string memory _name,uint _age, string memory _city,uint _CNIC, string memory _email) public {
        
        require(RegisteredAddressMapping[msg.sender] && (BuyerMapping[msg.sender].id == msg.sender));

        BuyerMapping[msg.sender].name = _name;
        BuyerMapping[msg.sender].age = _age;
        BuyerMapping[msg.sender].city = _city;
        BuyerMapping[msg.sender].CNIC = _CNIC;
        BuyerMapping[msg.sender].email = _email;
        
        
    }

    function getBuyer() public view returns( address [] memory ){
        return(buyers);
    }

    function getBuyerDetails(address i) public view returns ( string memory,string memory, uint, string memory,uint) {
        return (BuyerMapping[i].name,BuyerMapping[i].city ,BuyerMapping[i].CNIC, BuyerMapping[i].email, BuyerMapping[i].age);
    }


  

    function getRequestDetails (uint i) public view returns (address, address, uint, bool) {
        return(RequestsMapping[i].sellerId, RequestsMapping[i].buyerId, RequestsMapping[i].landId, RequestStatus[i]);
    }

    
    function isApproved(uint _id) public view returns (bool) {
        if(RequestStatus[_id]){
            return true;
        }
    }

 

    function LandOwnershipTransfer(uint _landId, address _newOwner) public{
        require(isLandInspector(msg.sender));

        LandOwner[_landId] = _newOwner;
    }

    function isPaid(uint _landId) public view returns (bool) {
        if(PaymentReceived[_landId]){
            return true;
        }
    }

    function payment(address payable _receiver, uint _landId) public payable {
        PaymentReceived[_landId] = true;
        _receiver.transfer(msg.value);
    }



}