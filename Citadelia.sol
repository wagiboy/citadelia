// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts@4.7.2/utils/Strings.sol";

contract Citadelia {

    address         public owner;
    Contributor[]   public contributors;
    Vendor[]        public vendors;
    Project[]       public projects;
    
    constructor() {
        owner = msg.sender;
    }

    /* -------------------------------------------------
     *  Roles/User structs
     * ------------------------------------------------ */  
    struct Contributor {
        string  name;
        address walletAddress;
    }

    struct Vendor {
        uint    vid;
        string  name;
        string  description;
        address payable walletAddress;
    }

    /* -------------------------------------------------
     *  Project structs
     * ------------------------------------------------ */
    struct Project {
        uint    pid;
        string  name;
        string  description;
        uint    minimumContribution;            // e.g 0.001 eth or 1 finney or 1000000000000000 wei
        address payable walletAddress;
        mapping(address => bool) contributors;  // list of the addresses of contributors who have donated for this project
        uint8   contributorsCount;
        SpendingRequest[] spendingRequests;
    }

    struct BasicProject {
        // used for returning Project data without arrays and mappings
        uint    pid;
        string  name;
        string  description;
        uint    minimumContribution;
        uint8   contributorsCount;
    }

    struct SpendingRequest {
        uint    srid;
        string  name;
        string  description;
        uint    amountInWei;
        uint    vid;                         // vendor who receives the amount of money in wei
        mapping(address => bool) approvals;  // wallet addresses of contributors who have approved this spending request
        uint8   approvalsCount;
        bool    complete;
    }

    struct BasicSpendingRequest {
        // used for returning SpendingRequest data without mapping
        uint    srid;
        string  name;
        string  description;
        uint    amountInWei;
        uint    vid;  // vendor who receives the amount of money in wei
        uint8   approvalsCount;
        bool    complete;
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

    function getProjects() external view ownerOnly returns (BasicProject[] memory) {
        BasicProject[] memory basicProjects = new BasicProject[](projects.length);
        for (uint8 i=0; i < projects.length; i++) {
            basicProjects[i].pid                 = projects[i].pid;
            basicProjects[i].name                = projects[i].name;
            basicProjects[i].description         = projects[i].description;
            basicProjects[i].minimumContribution = projects[i].minimumContribution;
            basicProjects[i].contributorsCount   = projects[i].contributorsCount;
        }
        return basicProjects;
    }

    function getSpendingRequests(uint8 pid) external view ownerOnly returns (BasicSpendingRequest[] memory) {
        require(pid != 0, "pid must be specified");

        SpendingRequest[] storage spendingRequests = projects[pid-1].spendingRequests;
        BasicSpendingRequest[] memory basicSpendingRequests = new BasicSpendingRequest[](spendingRequests.length);

        for (uint8 i=0; i < projects.length; i++) {
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
     *  preconditions (modifiers)
     * ------------------------------------------------ */    
    modifier ownerOnly() {
        require(msg.sender == owner, "Callee must be the contract owner to call this function.");
        _;
    }    

    /* -------------------------------------------------
     *  events
     * ------------------------------------------------ */    
    event Donation(address indexed contributor, uint amount, uint8 pid);
    event Approval(address indexed contributor, uint8 pid, uint8 srid);
    event Completion(uint8 pid, uint8 srid);


    /* -------------------------------------------------
     *  Creation of data functions
     * ------------------------------------------------ */ 
    function createContributor(string memory name, address contributorAddress) public ownerOnly {
        require(bytes(name).length != 0, "The contributor name is required.");
        require(contributorAddress != address(0), "The address of the contributor is required.");

        Contributor memory contributor = Contributor({
            name: name,
            walletAddress: contributorAddress
        });

        contributors.push(contributor);
    }

    function createVendor(string memory name, string memory description, address payable vendorAddress) public ownerOnly {
        require(bytes(name).length != 0,        "The vendor name is required.");
        require(bytes(description).length != 0, "An description of the vendor is required.");
        require(vendorAddress != address(0),    "The address of the vendor is required.");

        uint vid = vendors.length + 1;

        Vendor memory vendor = Vendor({
            vid: vid,
            name: name,
            description: description,
            walletAddress: vendorAddress
        });

        vendors.push(vendor);
    }

    function createProject(string memory name, string memory description, uint minimumContribution, address payable walletAddress) public ownerOnly {
        require(bytes(name).length != 0,        "The vendor name is required.");
        require(bytes(description).length != 0, "An description of the project is required.");
        require(minimumContribution != 0,       "A minimum contribution of the project is required.");
        require(walletAddress != address(0),    "A wallet address for the project is required.");
        
        uint i = projects.length;
        // cannot push struct onto array containing mapping. Only pushing empty is a workaround
        projects.push();
        Project storage project = projects[i];

        project.pid                 = i+1;
        project.name                = name;
        project.description         = description;
        project.minimumContribution = minimumContribution;
        project.walletAddress       = walletAddress;     
    }

    function createSpendingRequest(uint8 pid, string memory name, string memory description, uint amountToSpend, uint8 vid) public ownerOnly {
        require(pid != 0,                       "pid must be specified");
        require(bytes(name).length != 0,        "The name of the spending request is required.");
        require(bytes(description).length != 0, "An description of the spending request is required.");
        require(amountToSpend != 0,             "The amountToSpend is required.");
        require(vid != 0,                       "The vid of the vendor is required.");

        Project storage project = projects[pid-1];
        SpendingRequest[] storage spendingRequests = project.spendingRequests;
        uint i = project.spendingRequests.length;
        spendingRequests.push();
        SpendingRequest storage spendingRequest = project.spendingRequests[i];

        spendingRequest.srid        = i+1;  
        spendingRequest.name        = name;
        spendingRequest.description = description;
        spendingRequest.amountInWei = amountToSpend;
        spendingRequest.vid         = vid;
    }
    
    /* -------------------------------------------------
     *  Action functions
     * ------------------------------------------------ */ 
    function donate(uint8 pid) public payable {
        /* Contributors donate minimum eth to project with pid 
         * ---------------------------------------------------- */

        // assert pid is given
        require(pid != 0, "pid must be specified");

        // assert contributor exists
        bool contributorExists = false;
        for (uint8 i = 0; i < contributors.length; i++) {
            if (contributors[i].walletAddress == msg.sender) {
                contributorExists = true;
            }
        }
        require(contributorExists);
            
        Project storage project = projects[pid-1];

        // assert contributed amount of eth meets the minimum contribution
        require(msg.value >= project.minimumContribution, concat("contribution amount must be greater or equal to wei=", Strings.toString(project.minimumContribution)));

        // deposit contributed funds onto the project's account
        project.walletAddress.transfer(msg.value);

        // note that contributor has donated for this particular project
        project.contributors[msg.sender] = true;

        // increment contributor count
        project.contributorsCount++;

        emit Donation(msg.sender, msg.value, pid);
    }

    function approveSpendingRequest(uint8 pid, uint8 srid) public {
        /* Project contributors are permitted to approve (vote) 
         * for spending requests
         * -------------------------------------------------------------------- */

        // assert pid and srid are given
        require(pid  != 0, "pid must be specified");
        require(srid != 0, "srid must be specified");

        // fetching state variables 
        Project storage project                     = projects[pid-1];
        SpendingRequest storage spendingRequest     = project.spendingRequests[srid-1];
        mapping(address => bool) storage approvals  = spendingRequest.approvals;

        // assert caller/contributor has contributed to this project
        require(project.contributors[msg.sender]);

        // assert caller/contributor hasn't approved before
        require(!approvals[msg.sender]);

        // record new approval
        approvals[msg.sender] = true;
        spendingRequest.approvalsCount++;

        emit Approval(msg.sender, pid, srid);
    }

    function finalizeSpendingRequest(uint8 pid, uint8 srid) public ownerOnly {
        /* After sufficent approvals the project owner is permitted to transfer
         * the approved funds to the spending request's vendor.
         * -------------------------------------------------------------------- */

        // assert pid and srid are given
        require(pid  != 0, "pid must be specified");
        require(srid != 0, "srid must be specified");

        // fetching state variables 
        Project storage project                 = projects[pid-1];
        SpendingRequest storage spendingRequest = project.spendingRequests[srid-1];
        
        // assert SpendingRequest is not yet complete
        require(!spendingRequest.complete);

        // assert minimum 50% of project contributors have approved
        require(spendingRequest.approvalsCount >= project.contributorsCount / 2, "A minimum of 50% of project contributors must have approved this spending request before finalizing.");

        // transfer spending requests amound in wei to vendor
        vendors[spendingRequest.vid-1].walletAddress.transfer(spendingRequest.amountInWei);

        // mark this spending request as completed
        spendingRequest.complete = true;

        emit Completion(pid, srid);
    }

    /* -------------------------------------------------
     *  internal helper functions
     * ------------------------------------------------ */ 
    function concat(string memory a, string memory b) internal pure returns(string memory){
        /* concatenation of 2 strings 
         * -------------------------- */
        return (string(abi.encodePacked(a, b)));
    } 
}