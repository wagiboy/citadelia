// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts@4.7.2/utils/Strings.sol";
import "hardhat/console.sol";

/* -------------------------------------------------
 *  
 *  Citadelia - main contract, acts as 
 *    
 *      factory - for creating Project-contracts 
 *      facade  - for calling interface functions
 *
 * ------------------------------------------------ */  
contract Citadelia {

    address         public owner;
    Contributor[]   public contributors;
    Vendor[]        public vendors;
    address[]       public projects;

    constructor() {
        owner = msg.sender;
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Callee must be the contract owner to call this function.");
        _;
    } 

    /* -------------------------------------------------
     *  Roles/User structs
     * ------------------------------------------------ */  
    struct Contributor {
        uint8   cid;
        string  name;
        string  username;
        address walletAddress;
        uint    balance;
    }

    struct Vendor {
        uint8   vid;
        string  name;
        string  description;
        address payable walletAddress;
        uint    balance;
    }    

   /* -------------------------------------------------
    *  factory interface
    * ------------------------------------------------ */ 
    function createContributor(string memory name, string memory username, address contributorAddress) external ownerOnly {
        require(bytes(name).length != 0, "The contributor name is required.");
        require(contributorAddress != address(0), "The address of the contributor is required.");

        uint cid = contributors.length + 1;
        console.log("createContributor() cid=%s", cid);

        Contributor memory contributor = Contributor({
            cid: uint8(cid),
            name: name,
            username: username,
            walletAddress: contributorAddress,
            balance: contributorAddress.balance
        });

        contributors.push(contributor);
    }

    function createVendor(string memory name, string memory description, address payable vendorAddress) external ownerOnly {
        require(bytes(name).length != 0,        "The vendor name is required.");
        require(bytes(description).length != 0, "An description of the vendor is required.");
        require(vendorAddress != address(0),    "The address of the vendor is required.");

        uint vid = vendors.length + 1;
        console.log("createVendor() vid=%s", vid);

        Vendor memory vendor = Vendor({
            vid: uint8(vid),
            name: name,
            description: description,
            walletAddress: vendorAddress,
            balance: vendorAddress.balance
        });

        vendors.push(vendor);
    }

    function createProject(string memory name, string memory description, uint minimumContribution) external ownerOnly {
        require(bytes(name).length != 0,        "The vendor name is required.");
        require(bytes(description).length != 0, "An description of the project is required.");
        require(minimumContribution != 0,       "A minimum contribution of the project is required.");    

        Project project = new Project(name, description, minimumContribution, address(this));

        projects.push(project.getContractAddress());
    }

   /* -------------------------------------------------
    *  getter functions - returning arrays of structs
    * ------------------------------------------------ */ 
    function getContributors() external view ownerOnly returns (Contributor[] memory) {
        return contributors;
    }

    function getVendors() external view ownerOnly returns (Vendor[] memory) {
        return vendors;
    }

    function getVendorAddress(uint8 vid) public view returns (address payable) {
        require(vid != 0, "vid must be specified and greater than 0");
        return vendors[vid-1].walletAddress;
    }

    function getProjects() external view ownerOnly returns (address[] memory) { 
        return projects;
    }
}

/* -------------------------------------------------
 *  
 *  Project - contract , acts as 
 *    
 *      must be a contract because this is the only programmatic way 
 *     to store ethereum
 *
 * ------------------------------------------------ */  
contract Project {

    address public owner;
    Citadelia  citadelia;

    string  public name;
    string  public description;
    uint    public minimumContribution;          // e.g 0.001 eth or 1 finney or 1000000000000000 wei
    mapping(address => bool) contributors;  // list of the addresses of contributors who have donated for this project
    uint8   public contributorsCount;
    SpendingRequest[] spendingRequests;

    struct SpendingRequest {
        uint8   srid;
        string  name;
        string  description;
        uint    amountInWei;                 // amount of ether requested for spending request (how much does it cost)
        uint8   vid;                         // vendor who receives the amount of money in wei
        mapping(address => bool) approvals;  // wallet addresses of contributors who have approved this spending request
        uint8   approvalsCount;
        bool    complete;
    }

    struct BasicSpendingRequest {
        // used for returning SpendingRequest data without mapping
        uint8   srid;
        string  name;
        string  description;
        uint    amountInWei;
        uint8   vid;  // vendor who receives the amount of money in wei
        uint8   approvalsCount;
        bool    complete;
    }
    
    /* -------------------------------------------------
     *  constructor, modifiers, events
     * ------------------------------------------------- */    
    constructor(string memory _name, string memory _description, uint _minimumContribution, address _citadelia) {
        name                = _name;
        description         = _description;
        minimumContribution = _minimumContribution;
        citadelia           = Citadelia(_citadelia);

        owner = msg.sender;

        console.log("ctor Project() address=%s", address(this));
    }    
    
    modifier ownerOnly() {
        require(msg.sender == owner, "Callee must be the contract owner to call this function.");
        _;
    } 

    event Donation(address indexed contributor, uint amount, address project);
    event Approval(address indexed contributor, address project, uint8 srid);
    event Completion(address project, uint8 srid);

   /* -------------------------------------------------
    *  factory interface
    * ------------------------------------------------ */ 
    function createSpendingRequest(string memory _name, string memory _description, uint _amountToSpend, uint8 _vid) external ownerOnly {
        require(bytes(_name).length != 0,        "The name of the spending request is required.");
        require(bytes(_description).length != 0, "An description of the spending request is required.");
        require(_amountToSpend != 0,             "The amountToSpend is required.");
        require(_vid != 0,                       "The vid of the vendor is required and must be greater than 0.");

        spendingRequests.push();
        uint i = spendingRequests.length;
        SpendingRequest storage spendingRequest = spendingRequests[i-1];
        console.log("createSpendingRequest() srid=%d", i);        

        spendingRequest.srid        = uint8(i);  
        spendingRequest.name        = _name;
        spendingRequest.description = _description;
        spendingRequest.amountInWei = _amountToSpend;
        spendingRequest.vid         = _vid;
    }
          
    /* -------------------------------------------------
     *  getter functions - returning arrays of structs
     * ------------------------------------------------ */ 
    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function getSpendingRequests() external view ownerOnly returns (BasicSpendingRequest[] memory) {

        BasicSpendingRequest[] memory basicSpendingRequests = new BasicSpendingRequest[](spendingRequests.length);

        for (uint8 i=0; i < spendingRequests.length; i++) {
            basicSpendingRequests[i].srid           = spendingRequests[i].srid;
            basicSpendingRequests[i].name           = spendingRequests[i].name;
            basicSpendingRequests[i].description    = spendingRequests[i].description;
            basicSpendingRequests[i].amountInWei    = spendingRequests[i].amountInWei;
            basicSpendingRequests[i].vid            = spendingRequests[i].vid;
            basicSpendingRequests[i].approvalsCount = spendingRequests[i].approvalsCount;
            basicSpendingRequests[i].complete       = spendingRequests[i].complete;
        }
        return basicSpendingRequests;
    }

    /* -------------------------------------------------
     *  public interface
     * ------------------------------------------------ */ 
    function fund() external payable {
        /* Contributors fund this project
         * with a minimum amount of ether
         * ------------------------------- */

        // assert contributed amount of ether meets the minimum requirement
        require(msg.value >= minimumContribution, concat("contribution amount must be greater or equal to wei=", Strings.toString(minimumContribution)));

        // note that contributor has funded for this particular project
        contributors[msg.sender] = true;

        // increment contributor count
        contributorsCount++;

        console.log("fund() amount=%d", msg.value);        

        emit Donation(msg.sender, msg.value, address(this));
    }    


    function approveSpendingRequest(uint8 srid) external {
        /* Project contributors are permitted to approve (vote) for spending requests
         * --------------------------------------------------------------------------- */
        // assert srid is given
        require(srid != 0, "srid must be specified and be greater than 0");

        // fetching state variables 
        SpendingRequest storage spendingRequest     = spendingRequests[srid-1];
        mapping(address => bool) storage approvals  = spendingRequest.approvals;

        // assert caller/contributor has contributed to this project
        require(contributors[msg.sender], "caller has not contributed to the project");

        // assert caller/contributor hasn't approved before
        require(!approvals[msg.sender], "caller has already approved this spending request");

        // record new approval
        approvals[msg.sender] = true;
        spendingRequest.approvalsCount++;

        console.log("approveSpendingRequest(srid=%d)", srid);           

        emit Approval(msg.sender, address(this), srid);
    }

    function canSpendingRequestBeCompleted(uint8 srid) external view returns (bool) {
        /* returns true if the spending request srid 
         * has 50% or more of the contributer's votes/approvals
         * ----------------------------------------------------- */
        require(srid != 0, "srid must be specified and be greater than 0");        
        return fiftyPercentOrMore(spendingRequests[srid-1]);
    }

    function completeSpendingRequest(uint8 srid) external {
        /* After sufficent approvals the project owner is permitted to transfer
         * the approved funds to the spending request's vendor.
         * -------------------------------------------------------------------- */
        // assert srid is given
        require(srid != 0, "srid must be specified and greater than 0");

        console.log("completeSpendingRequest(srid=%d)", srid);           
       
        // fetching state variables 
        SpendingRequest storage spendingRequest = spendingRequests[srid-1];
        
        // asser caller is a project contributor
        require(contributors[msg.sender], "caller is not a project contibutor");

        // assert SpendingRequest is not yet complete
        require(!spendingRequest.complete, "spending request has already been completed");

        // assert minimum 50% of project contributors have approved
        require(fiftyPercentOrMore(spendingRequest), "A minimum of 50% of project contributors must have approved this spending request before completion.");

        // transfer spending request's amount in wei to the wallet of the vendor      
        address payable vendorWalletAddress = citadelia.getVendorAddress(spendingRequest.vid);
        vendorWalletAddress.transfer(spendingRequest.amountInWei);
        //vendorWalletAddress.call{value: spendingRequest.amountInWei}(abi.encode(spendingRequest.amountInWei));

        // mark this spending request as completed
        spendingRequest.complete = true;

        emit Completion(address(this), srid);
    }

    /* -------------------------------------------------
     *  internal helper functions
     * ------------------------------------------------ */ 
    function concat(string memory a, string memory b) internal pure returns(string memory){
        /* concatenation of 2 strings 
         * -------------------------- */
        return (string(abi.encodePacked(a, b)));
    } 

    function fiftyPercentOrMore(SpendingRequest storage _spendingRequest) internal view returns (bool) {
        /* returns true of the spending request's approvalCount
         * is 50% or more of the number of project contributors
         * ----------------------------------------------------- */
        if (_spendingRequest.approvalsCount == 0) {
            return false;
        } else {
            return (_spendingRequest.approvalsCount >= contributorsCount / 2);
        }
    }
}