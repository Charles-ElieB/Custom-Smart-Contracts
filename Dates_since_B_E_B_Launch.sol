// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract BlockchainEpochCounter {
    // Timestamps des dates de lancement des blockchains
    uint256 constant BITCOIN_CREATION_TIMESTAMP = 1231006500; // 3 janvier 2009, 18:15 UTC
    uint256 constant ETHEREUM_CREATION_TIMESTAMP = 1438277160; // 30 juillet 2015, 15:26 UTC
    uint256 constant BASE_CREATION_TIMESTAMP = 1691596800; // 9 août 2023, 16:00 UTC

    /// @notice Retourne une chaîne de caractères indiquant la date en jours/mois/année depuis le lancement de Bitcoin
    function SinceBitcoinTheDadLaunch() public view returns (string memory) {
        return _getFormattedDate(BITCOIN_CREATION_TIMESTAMP);
    }

    /// @notice Retourne une chaîne de caractères indiquant la date en jours/mois/année depuis le lancement d'Ethereum
    function SinceEthereumTheMotherLaunch() public view returns (string memory) {
        return _getFormattedDate(ETHEREUM_CREATION_TIMESTAMP);
    }

    /// @notice Retourne une chaîne de caractères indiquant la date en jours/mois/année depuis le lancement de Base
    function SinceBaseThePrettyChildLaunch() public view returns (string memory) {
        return _getFormattedDate(BASE_CREATION_TIMESTAMP);
    }

    /// @dev Calcule la date (année, mois, jour) en fonction du timestamp de départ
    /// @param startTimestamp Timestamp de départ (zéro absolu)
    /// @return FormattedDate Une chaîne de caractères formatée en jours/mois/année
    function _getFormattedDate(uint256 startTimestamp)
        internal
        view
        returns (string memory)
    {
        require(
            block.timestamp >= startTimestamp,
            "Current time is before the blockchain launch date."
        );
        uint256 elapsedDays = (block.timestamp - startTimestamp) / 1 days;

        (uint256 year, uint256 month, uint256 day) = _calculateDate(elapsedDays);

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
    function _calculateDate(uint256 _days)
        internal
        pure
        returns (
            uint256 year,
            uint256 month,
            uint256 day
        )
    {
        year = 2009; // Année de départ par défaut

        // Nombre de jours dans chaque mois
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
            if (_isLeapYear(year)) {
                if (_days >= 366) {
                    _days -= 366;
                    year++;
                }
            } else {
                _days -= 365;
                year++;
            }
        }

        if (_isLeapYear(year)) {
            daysInMonth[1] = 29; // Ajuste Février pour une année bissextile
        }

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
