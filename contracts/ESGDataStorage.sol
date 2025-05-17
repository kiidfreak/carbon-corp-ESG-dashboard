pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Contract to store and manage ESG data for companies
contract ESGDataStorage is Context {
    using Counters for Counters.Counter;

    // Struct to represent ESG data entry
    struct ESGData {
        uint256 timestamp; // When the data was recorded
        uint256 carbonEmissions; // Carbon emissions in metric tons (CO2e)
        uint256 energyConsumption; // Energy consumption in kWh
        uint256 sustainabilityScore; // Custom ESG score (0-100)
        string metadata; // Additional data (e.g., IPFS hash for detailed report)
    }

    // Mapping from company address to their ESG data entries
    mapping(address => ESGData[]) private _companyData;

    // Counter for data entry IDs
    Counters.Counter private _dataIdCounter;

    // Event emitted when new ESG data is added
    event ESGDataAdded(
        address indexed company,
        uint256 dataId,
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string metadata
    );

    // Event emitted when ESG data is updated
    event ESGDataUpdated(
        address indexed company,
        uint256 dataId,
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string metadata
    );

    // Add new ESG data for the calling company
    function addESGData(
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string memory metadata
    ) external {
        require(sustainabilityScore <= 100, "Sustainability score must be 0-100");
        address company = _msgSender();
        uint256 dataId = _dataIdCounter.current();

        _companyData[company].push(
            ESGData(block.timestamp, carbonEmissions, energyConsumption, sustainabilityScore, metadata)
        );
        _dataIdCounter.increment();

        emit ESGDataAdded(
            company,
            dataId,
            carbonEmissions,
            energyConsumption,
            sustainabilityScore,
            metadata
        );
    }

    // Update existing ESG data for a specific data ID
    function updateESGData(
        uint256 dataId,
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string memory metadata
    ) external {
        require(sustainabilityScore <= 100, "Sustainability score must be 0-100");
        address company = _msgSender();
        require(dataId < _companyData[company].length, "Invalid data ID");

        ESGData storage data = _companyData[company][dataId];
        data.carbonEmissions = carbonEmissions;
        data.energyConsumption = energyConsumption;
        data.sustainabilityScore = sustainabilityScore;
        data.metadata = metadata;
        data.timestamp = block.timestamp;

        emit ESGDataUpdated(
            company,
            dataId,
            carbonEmissions,
            energyConsumption,
            sustainabilityScore,
            metadata
        );
    }

    // Retrieve ESG data for a company by data ID
    function getESGData(address company, uint256 dataId)
        external
        view
        returns (ESGData memory)
    {
        require(dataId < _companyData[company].length, "Invalid data ID");
        return _companyData[company][dataId];
    }

    // Retrieve all ESG data entries for a company
    function getAllESGData(address company)
        external
        view
        returns (ESGData[] memory)
    {
        return _companyData[company];
    }

    // Get the total number of data entries for a company
    function getDataCount(address company) external view returns (uint256) {
        return _companyData[company].length;
    }
}