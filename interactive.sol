pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

/**
 * Smart Contract that allows interactivity with the real world
 */
contract Interactive is ChainlinkClient {
    //variables
    //storing actionFee amount needed for the event
    address public owner;
    uint256 public actionFee;

    //varaibles for Chainlink Oracle
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint256) private _deposits;

    constructor() public {
        owner = msg.sender;
        actionFee = 0.001 ether;

        //Network: Kovan
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    /**
     * Deposit eth to this contract
     */
    function deposit() public payable {
        _deposits[msg.sender] += msg.value;

        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint amount) public returns(bool) {
        require(_deposits[msg.sender] >= amount);
        _deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);

        emit Withdrawn(msg.sender, amount);
        return true;

    }

    /**
     * Check the deposited value of the given address
     */
    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }

    /**
     * Calls WebAPI using Chainlink with the given color, if there are enough funds deposited by the calling address
     */
    function setColor(string memory color) public payable returns (bytes32 requestId) {
        if(msg.value != actionFee)
        {
            if(msg.value > 0)
            {
                _deposits[msg.sender] += msg.value;
                emit Deposited(msg.sender, msg.value);
        
            }

            //Check if you have deposited enough funds
            require(_deposits[msg.sender] >= actionFee);

            //Subtract the fee needed for the action
            _deposits[msg.sender] -= actionFee;
            emit Withdrawn(msg.sender, actionFee);

        }
        
        //Add funds to owner
        _deposits[owner] += actionFee;

        //Create Chainlink Request
        Chainlink.Request memory request =
            buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        //TODO: URL should be moved to a Job Request
        request.add(
            "get",
            string(
                abi.encodePacked(
                    "https://chainlink-interactive.azurewebsites.net/webhook?color=",
                    color
                )
            )
        );

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Owner can set the color without funds
     */
    function setColorByOwner(string memory color)
        public
        returns (bytes32 requestId)
    {
        require(msg.sender == owner);
        Chainlink.Request memory request =
            buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        request.add(
            "get",
            string(
                abi.encodePacked(
                    "https://chainlink-interactive.azurewebsites.net/webhook?color=",
                    color
                )
            )
        );

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Callback function for Chainlink GET request
     */
    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {}
}
