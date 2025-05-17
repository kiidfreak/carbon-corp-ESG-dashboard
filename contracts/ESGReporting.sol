pragma solidity ^0.8.20;

import "./ESGDataStorage.sol";
import "./ESGAccessControl.sol";

// Contract to handle ESG reporting and auditing
contract ESGReporting {
    ESGDataStorage private _dataStorage;
    ESGAccessControl private _accessControl;

    // Event emitted when a report is audited
    event ReportAudited(
        address indexed company,
        uint256 dataId,
        address indexed auditor,
        bool isValid,
        string comments
    );

    constructor(address dataStorageAddress, address accessControlAddress) {
        _dataStorage = ESGDataStorage(dataStorageAddress);
        _accessControl = ESGAccessControl(accessControlAddress);
    }

    // Modifier to restrict functions to companies
    modifier onlyCompany() {
        require(
            _accessControl.hasRoleCheck(msg.sender, "COMPANY"),
            "Caller is not a company"
        );
        _;
    }

    // Modifier to restrict functions to auditors
    modifier onlyAuditor() {
        require(
            _accessControl.hasRoleCheck(msg.sender, "AUDITOR"),
            "Caller is not an auditor"
        );
        _;
    }

    // Submit new ESG data (wrapper for data storage)
    function submitESGReport(
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string memory metadata
    ) external onlyCompany {
        _dataStorage.addESGData(
            carbonEmissions,
            energyConsumption,
            sustainabilityScore,
            metadata
        );
    }

    // Update existing ESG data
    function updateESGReport(
        uint256 dataId,
        uint256 carbonEmissions,
        uint256 energyConsumption,
        uint256 sustainabilityScore,
        string memory metadata
    ) external onlyCompany {
        _dataStorage.updateESGData(
            dataId,
            carbonEmissions,
            energyConsumption,
            sustainabilityScore,
            metadata
        );
    }

    // Audit an ESG report
    function auditReport(
        address company,
        uint256 dataId,
        bool isValid,
        string memory comments
    ) external onlyAuditor {
        require(dataId < _dataStorage.getDataCount(company), "Invalid data ID");
        emit ReportAudited(company, dataId, msg.sender, isValid, comments);
    }

    // Retrieve ESG data (publicly accessible)
    function getESGReport(address company, uint256 dataId)
        external
        view
        returns (ESGDataStorage.ESGData memory)
    {
        return _dataStorage.getESGData(company, dataId);
    }

    // Retrieve all ESG reports for a company
    function getAllESGReports(address company)
        external
        view
        returns (ESGDataStorage.ESGData[] memory)
    {
        return _dataStorage.getAllESGData(company);
    }
}