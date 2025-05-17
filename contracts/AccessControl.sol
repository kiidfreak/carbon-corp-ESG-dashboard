pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

// Contract to manage roles for ESG platform
contract ESGAccessControl is AccessControl {
    // Define roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant COMPANY_ROLE = keccak256("COMPANY_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    // Constructor sets up the default admin
    constructor() {
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        _setRoleAdmin(COMPANY_ROLE, ADMIN_ROLE);
        _setRoleAdmin(AUDITOR_ROLE, ADMIN_ROLE);

        _grantRole(ADMIN_ROLE, msg.sender);
    }

    // Modifier to restrict functions to admins
    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        _;
    }

    // Modifier to restrict functions to companies
    modifier onlyCompany() {
        require(hasRole(COMPANY_ROLE, msg.sender), "Caller is not a company");
        _;
    }

    // Modifier to restrict functions to auditors
    modifier onlyAuditor() {
        require(hasRole(AUDITOR_ROLE, msg.sender), "Caller is not an auditor");
        _;
    }

    // Add a new company
    function addCompany(address account) external onlyAdmin {
        grantRole(COMPANY_ROLE, account);
    }

    // Remove a company
    function removeCompany(address account) external onlyAdmin {
        revokeRole(COMPANY_ROLE, account);
    }

    // Add a new auditor
    function addAuditor(address account) external onlyAdmin {
        grantRole(AUDITOR_ROLE, account);
    }

    // Remove an auditor
    function removeAuditor(address account) external onlyAdmin {
        revokeRole(AUDITOR_ROLE, account);
    }

    // Check if an address has a specific role
    function hasRoleCheck(address account, string memory role)
        external
        view
        returns (bool)
    {
        if (keccak256(abi.encodePacked(role)) == keccak256("ADMIN")) {
            return hasRole(ADMIN_ROLE, account);
        } else if (keccak256(abi.encodePacked(role)) == keccak256("COMPANY")) {
            return hasRole(COMPANY_ROLE, account);
        } else if (keccak256(abi.encodePacked(role)) == keccak256("AUDITOR")) {
            return hasRole(AUDITOR_ROLE, account);
        }
        return false;
    }
}