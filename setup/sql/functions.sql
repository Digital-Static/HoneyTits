DELIMITER //
CREATE FUNCTION geoip.country_code(ip VARCHAR(100)) RETURNS TINYTEXT READS SQL DATA
BEGIN
  DECLARE code TINYTEXT;
  SELECT country_code
  FROM (
	SELECT * 
	FROM geoip.geocountry 
	WHERE INET6_ATON(ip) <= network_end
	LIMIT 1
  ) AS a 
  INNER JOIN geoip.countrylocations AS b on a.geoname_id = b.geoname_id
  WHERE network_start <= INET6_ATON(ip) INTO code;

  RETURN code;
END
//
DELIMITER ;
