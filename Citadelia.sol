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
     *  Project structs
     * ------------------------------------------------ */
    struct Project {
        uint8   pid;
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
        uint    balance;
    }

    struct SpendingRequest {
        uint    srid;
        string  name;
        string  description;
        uint    amountInWei;                 // amount of ether requested for spending request (how much does it cost)
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
     *  preconditions (modifiers)
     * ------------------------------------------------ */    
    modifier ownerOnly() {
        require(msg.sender == owner, "Callee must be the contract owner to call this function.");
        _;
    } 

    /* -------------------------------------------------
     *  Creation of data functions
     * ------------------------------------------------ */ 
    function createContributor(string memory name, string memory username, address contributorAddress) public ownerOnly {
        require(bytes(name).length != 0, "The contributor name is required.");
        require(contributorAddress != address(0), "The address of the contributor is required.");

        uint cid = contributors.length + 1;

        Contributor memory contributor = Contributor({
            cid: uint8(cid),
            name: name,
            username: username,
            walletAddress: contributorAddress,
            balance: contributorAddress.balance
        });

        contributors.push(contributor);
    }

    function createVendor(string memory name, string memory description, address payable vendorAddress) public ownerOnly {
        require(bytes(name).length != 0,        "The vendor name is required.");
        require(bytes(description).length != 0, "An description of the vendor is required.");
        require(vendorAddress != address(0),    "The address of the vendor is required.");

        uint vid = vendors.length + 1;

        Vendor memory vendor = Vendor({
            vid: uint8(vid),
            name: name,
            description: description,
            walletAddress: vendorAddress,
            balance: vendorAddress.balance
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

        project.pid                 = uint8(i+1);
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
            basicProjects[i].balance             = projects[i].walletAddress.balance;
        }
        return basicProjects;
    }

    function getSpendingRequests(uint8 pid) external view ownerOnly returns (BasicSpendingRequest[] memory) {
        require(pid != 0, "pid must be specified");

        SpendingRequest[] storage spendingRequests = projects[pid-1].spendingRequests;
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
     *  events
     * ------------------------------------------------ */    
    event Donation(address indexed contributor, uint amount, uint8 pid);
    event Approval(address indexed contributor, uint8 pid, uint8 srid);
    event Completion(uint8 pid, uint8 srid);

    /* -------------------------------------------------
     *  Action functions
     * ------------------------------------------------ */ 
    function fundProject(uint8 pid) public payable {
        /* Contributors fund project 'pid' 
         * with a minimum amount of ether
         * ------------------------------- */

        // assert pid is given
        require(pid != 0, "pid must be specified");

        // assert caller is an existing contributor
        bool contributorExists = false;
        for (uint8 i = 0; i < contributors.length; i++) {
            if (contributors[i].walletAddress == msg.sender) {
                contributorExists = true;
            }
        }
        require(contributorExists, "caller is not an existing contributor");
            
        Project storage project = projects[pid-1];

        // assert contributed amount of ether meets the minimum requirement
        require(msg.value >= project.minimumContribution, concat("contribution amount must be greater or equal to wei=", Strings.toString(project.minimumContribution)));

        // deposit contributed funds onto the project's account
        project.walletAddress.transfer(msg.value);

        // note that contributor has funded for this particular project
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
        require(project.contributors[msg.sender], "caller has not contributed to the project");

        // assert caller/contributor hasn't approved before
        require(!approvals[msg.sender], "caller has already approved this spending request");

        // record new approval
        approvals[msg.sender] = true;
        spendingRequest.approvalsCount++;

        emit Approval(msg.sender, pid, srid);
    }

    function canSpendingRequestBeCompleted(uint8 pid, uint8 srid) public view returns (bool) {
        /* returns true if the spending request srid for project pid 
         * has 50% or more of the contributer's votes/approvals
         * ----------------------------------------------------- */        
        return fiftyPercentOrMore( projects[pid-1], projects[pid-1].spendingRequests[srid-1] );
    }

    function completeSpendingRequest(uint8 pid, uint8 srid) public {
        /* After sufficent approvals the project owner is permitted to transfer
         * the approved funds to the spending request's vendor.
         * -------------------------------------------------------------------- */

        // assert pid and srid are given
        require(pid  != 0, "pid must be specified");
        require(srid != 0, "srid must be specified");

        // fetching state variables 
        Project storage project                 = projects[pid-1];
        SpendingRequest storage spendingRequest = project.spendingRequests[srid-1];
        
        // asser caller is a project contributor
        require(project.contributors[msg.sender], "caller is not a project contibutor");

        // assert SpendingRequest is not yet complete
        require(!spendingRequest.complete, "spending request has already been completed");

        // assert minimum 50% of project contributors have approved
        require(fiftyPercentOrMore(project, spendingRequest), "A minimum of 50% of project contributors must have approved this spending request before completion.");

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

    function fiftyPercentOrMore(Project storage project, SpendingRequest storage spendingRequest) internal view returns (bool) {
        /* returns true of the spending request's approvalCount
         * is 50% or more of the number of project contributors
         * ----------------------------------------------------- */
        if (spendingRequest.approvalsCount == 0) {
            return false;
        } else {
            return (spendingRequest.approvalsCount >= project.contributorsCount / 2);
        }
    }
}