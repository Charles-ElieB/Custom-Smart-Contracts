// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BitcoinEpochCounter {
    // Timestamp de la création de Bitcoin (3 janvier 2009, 00:00:00 UTC)
    uint256 constant BITCOIN_CREATION_TIMESTAMP = 1230940800; // Unix time en secondes

    /// @notice Retourne le timestamp actuel en secondes
    /// @return SecondsSinceOrigin Le timestamp actuel
    function getSecondsSinceOrigin() public view returns (uint256) {
        return block.timestamp;
    }

    /// @notice Calcule le nombre de jours écoulés depuis la création de Bitcoin
    /// @return DaysSinceOrigin Nombre de jours écoulés
    function getDaysSinceOrigin() public view returns (uint256) {
        require(
            block.timestamp >= BITCOIN_CREATION_TIMESTAMP,
            "Current time is before Bitcoin creation."
        );
        return (block.timestamp - BITCOIN_CREATION_TIMESTAMP) / 1 days;
    }

    /// @notice Retourne une chaîne de caractères indiquant la date en jours/mois/année depuis Bitcoin creation
    /// @return Thedate Une chaîne formatée
    function getThedate() public view returns (string memory) {
        uint256 daysSince = getDaysSinceOrigin();
        (uint256 year, uint256 month, uint256 day) = _calculateDate(daysSince);
        return string(
            abi.encodePacked(
                uintToString(day),
                "/",
                uintToString(month),
                "/",
                uintToString(year)
            )
        );
    }

    /// @dev Calcule la date (année, mois, jour) en fonction des jours écoulés
    /// @param _days Nombre de jours écoulés
    /// @return year Année calculée (relative à 2009 comme année 0)
    /// @return month Mois calculé
    /// @return day Jour calculé
    function _calculateDate(uint256 _days)
        internal
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        year = 0; // Année relative à 2009 comme "année 0"

        // Déclarez explicitement les éléments du tableau comme uint256
        uint256[12] memory daysInMonth = [
            uint256(31), // Janvier
            uint256(28), // Février
            uint256(31), // Mars
            uint256(30), // Avril
            uint256(31), // Mai
            uint256(30), // Juin
            uint256(31), // Juillet
            uint256(31), // Août
            uint256(30), // Septembre
            uint256(31), // Octobre
            uint256(30), // Novembre
            uint256(31)  // Décembre
        ];

        while (_days >= 365) {
            // Vérification des années bissextiles
            if (_isLeapYear(2009 + year)) {
                if (_days >= 366) {
                    _days -= 366;
                    year++;
                }
            } else {
                _days -= 365;
                year++;
            }
        }

        // Mise à jour pour Février si l'année est bissextile
        if (_isLeapYear(2009 + year)) {
            daysInMonth[1] = 29;
        }

        // Calcul du mois et du jour
        for (uint256 i = 0; i < 12; i++) {
            if (_days < daysInMonth[i]) {
                month = i + 1;
                day = _days + 1;
                break;
            }
            _days -= daysInMonth[i];
        }
    }

    /// @dev Vérifie si une année est bissextile
    /// @param _year Année à vérifier
    /// @return isLeap Vrai si bissextile, sinon faux
    function _isLeapYear(uint256 _year) internal pure returns (bool) {
        if (_year % 4 == 0) {
            if (_year % 100 == 0) {
                return _year % 400 == 0;
            }
            return true;
        }
        return false;
    }

    /// @dev Convertit un uint256 en chaîne de caractères
    /// @param _value L'entier à convertir
    /// @return La chaîne correspondant à l'entier
    function uintToString(uint256 _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint256 temp = _value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_value % 10)));
            _value /= 10;
        }
        return string(buffer);
    }
}
