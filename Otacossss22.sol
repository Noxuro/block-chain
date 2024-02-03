// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OTacosFranchise {
    struct Order {
        uint price;
        string size;
        string[] meats;
        string[] sauces;
        string[] supplements;
        string drink;
        bool takeaway;
    }

    struct Franchise {
        address franchiseAddress;
        string franchiseName;
        mapping(uint => Order) orders;
        uint orderCount;
    }

    mapping(address => Franchise) public franchises;
    address[] public franchiseAddresses;

    constructor() {
    // Create a new Franchise instance
    Franchise storage newFranchise = franchises[msg.sender];

    // Assign values to the newFranchise instance
    newFranchise.franchiseAddress = msg.sender;
    newFranchise.franchiseName = "Grand OTacos";
    newFranchise.orderCount = 0;  // Initialize orderCount to 0

    // Add the newFranchise to the franchiseAddresses array
    franchiseAddresses.push(msg.sender);
}



    function calculatePrice(string memory _size, string[] memory _meats, string[] memory _supplements, string memory _drink) private pure returns (uint) {
    // Define the price mappings for sizes, meats, supplements, and drinks
    uint basePrice;
    if (keccak256(bytes(_size)) == keccak256(bytes("M"))) {
        basePrice = 500; // 5€ in cents
    } else if (keccak256(bytes(_size)) == keccak256(bytes("L"))) {
        basePrice = 600; // 6€ in cents
    } else if (keccak256(bytes(_size)) == keccak256(bytes("XL"))) {
        basePrice = 900; // 9€ in cents
    } else if (keccak256(bytes(_size)) == keccak256(bytes("XXL"))) {
        basePrice = 1400; // 14€ in cents
    }

    uint meatsPrice;
    for (uint i = 0; i < _meats.length; i++) {
        // Add prices for selected meats
        if (keccak256(bytes(_meats[i])) == keccak256(bytes("tenders"))) {
            meatsPrice += 1 ether; // 1€ in ethers for "tenders"
        }
        // Other meats are free
    }

    uint supplementsPrice;
    for (uint i = 0; i < _supplements.length; i++) {
        // Add prices for selected supplements
        if (
            keccak256(bytes(_supplements[i])) == keccak256(bytes("CHEDDAR")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("RACLETTE")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("BOURSIN")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("CHEVRE")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("MOZZARELLA")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("VACHE QUI RIT"))
        ) {
            supplementsPrice += 0.5 ether; // 0.5€ in ethers
        } else if (
            keccak256(bytes(_supplements[i])) == keccak256(bytes("PASTRAMI")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("JAMBON DE DINDE")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("LARDONS DE DINDE")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("BACON DE DINDE")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("BLANC DE POULET")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("CHAMPIGNONS")) ||
            keccak256(bytes(_supplements[i])) == keccak256(bytes("POIVRONNADE"))
        ) {
            supplementsPrice += 0.9 ether; // 0.9€ in ethers
        }
        // Add prices for other supplements as needed
    }

    uint drinksPrice;
    // Add prices for selected drinks
    if (
        keccak256(bytes(_drink)) == keccak256(bytes("COCA COLA")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("COCA COLA ZERO")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("COCA COLA CHERRY")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("OASIS TROPICAL")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("OASIS POMME-CASSIS-FRAMBOISE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("CRISTALINE FRAISE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("CRISTALINE PECHE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("PERRIER")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("SEVEN UP MOJITO")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("LIPTON ICE TEA PECHE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("TROPICO")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("FANTA ORANGE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("CAPRISUN MULTIVITAMINE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("ARIZONA GRENADE")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("ARIZONA WATERMELON")) ||
        keccak256(bytes(_drink)) == keccak256(bytes("ICE TEA GREEN CITRON VERT / MENTHE"))
    ) {
        drinksPrice = 1.5 ether; // 1.5€ in ethers
    }
    // Add prices for other drinks as needed

    return basePrice + meatsPrice + supplementsPrice + drinksPrice;
}


    function addOrder(
        string memory _size,
        string[] memory _meats,
        string[] memory _sauces,
        string[] memory _supplements,
        string memory _drink,
        bool _takeaway
    ) public {
        uint price = calculatePrice(_size, _meats, _supplements, _drink);

        // Get the franchise's order count
        Franchise storage franchise = franchises[msg.sender];

        // Add the order to the franchise's orders
        franchise.orders[franchise.orderCount] = Order(price, _size, _meats, _sauces, _supplements, _drink, _takeaway);
        franchise.orderCount++;
}


    function getFranchiseOrderCount() public view returns (uint) {
        // Get the franchise's order count
        Franchise storage franchise = franchises[msg.sender];
        return franchise.orderCount;
    }

    function getFranchiseOrder(uint _index) public view returns (Order memory) {
        // Get a specific order for the franchise
        Franchise storage franchise = franchises[msg.sender];
        require(_index < franchise.orderCount, "Order index out of bounds");
        return franchise.orders[_index];
    }

    function getAllFranchiseAddresses() public view returns (address[] memory) {
        // Get all franchise addresses
        return franchiseAddresses;
    }
}
