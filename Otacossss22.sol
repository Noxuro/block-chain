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


    function calculatePrice(string memory _size, string[] memory _meats, string[] memory _supplements, string memory _drink) private pure returns (uint) {
        // Define the price mappings for sizes, meats, supplements, and drinks
        uint basePrice;
        if (keccak256(bytes(_size)) == keccak256(bytes("M"))) {
            basePrice = 500; // 5€ in cents
        } else if (keccak256(bytes(_size)) == keccak256(bytes("L"))) {
            basePrice = 750; // 6€ in cents
        } else if (keccak256(bytes(_size)) == keccak256(bytes("XL"))) {
            basePrice = 900; // 9€ in cents
        } else if (keccak256(bytes(_size)) == keccak256(bytes("XXL"))) {
            basePrice = 1400; // 14€ in cents
        }

        uint meatsPrice;
        for (uint i = 0; i < _meats.length; i++) {
            // Add prices for selected meats
            if (keccak256(bytes(_meats[i])) == keccak256(bytes("tenders"))) {
                meatsPrice += 100; // 1€ in ethers for "tenders"
            }
            // Other meats are free
        }

        uint supplementsPrice;
        for (uint i = 0; i < _supplements.length; i++) {
            // Add prices for selected supplements
            if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("cheddar"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("raclette"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("boursin"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("chevre"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("mozzarella"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("vache qui rit"))
            ) {
                supplementsPrice += 50; // 0.5€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("pastrami"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("jambon de dinde"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("lardon de dinde"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("bacon de dinde"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("blanc de poulet"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("champignons"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
            }if (
                keccak256(bytes(_supplements[i])) == keccak256(bytes("poivronnade"))
            ) {
                supplementsPrice += 90; // 0.9€ in ethers
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
            drinksPrice = 150; // 1.5€ in ethers
        }
        // Add prices for other drinks as needed

        return basePrice + meatsPrice + supplementsPrice + drinksPrice;
}
    function CreateFranchise(
        address _franchiseAddress,
        string memory _franchiseName
    ) public  {
        Franchise storage newFranchise=franchises[msg.sender];

        newFranchise.franchiseAddress=_franchiseAddress;
        newFranchise.franchiseName= _franchiseName;
        newFranchise.orderCount=0;

        franchiseAddresses.push(msg.sender);
    }

    function addOrder(
        string memory _franchiseName,
        string memory _size,
        string[] memory _meats,
        string[] memory _sauces,
        string[] memory _supplements,
        string memory _drink,
        bool _takeaway
        ) public {
        uint price = calculatePrice(_size, _meats, _supplements, _drink);
        address FAddress;
        // Get the franchise's order count
        for (uint i=0; i < franchiseAddresses.length; i++)
            if (keccak256(bytes(franchises[franchiseAddresses[i]].franchiseName)) == keccak256(bytes(_franchiseName))){
                FAddress=franchises[franchiseAddresses[i]].franchiseAddress;
                break;
            }
        Franchise storage franchise = franchises[FAddress];

        // Add the order to the franchise's orders
        franchise.orders[franchise.orderCount] = Order(price, _size, _meats, _sauces, _supplements, _drink, _takeaway);
        franchise.orderCount++;
}
    
    function getFranchiseOrderCount(address _franchiseAddress) public view returns (uint) {
        // Get the franchise's order count
        Franchise storage franchise = franchises[_franchiseAddress];
        return franchise.orderCount;
    }

    function getFranchiseOrder(address _franchiseAddress, uint _index) public view returns (Order memory) {
        // Get a specific order for the franchise
        Franchise storage franchise = franchises[_franchiseAddress];
        require(_index < franchise.orderCount, "Order index out of bounds");
        return franchise.orders[_index];
    }

    function getAllFranchiseAddresses() public view returns (address[] memory) {
        // Get all franchise addresses
        return franchiseAddresses;
    }
    
    function getAllFranchiseBeneficeOrder()public view returns (uint){
        uint AllBenefice;
        for (uint i=0; i < franchiseAddresses.length; i++){
            AllBenefice+= getFranchiseBeneficeOrder(franchiseAddresses[i]);
        }
        return AllBenefice;
    }
    function getFranchiseBeneficeOrder(address _franchiseAddress)public view returns (uint){
        uint Benefice;
        // Get all order for the franchise
        Franchise storage franchise = franchises[_franchiseAddress];
        for (uint i = 0; i < franchise.orderCount; i++) {
            Benefice += franchise.orders[i].price;
        }
        return Benefice;
    }
}
