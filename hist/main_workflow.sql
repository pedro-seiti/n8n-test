SELECT 
    c.id AS client_id,
    c.name,
    ROUND(AVG(r.kwh_value), 2) AS consumption_in_kwh
FROM 
    energy.clients c
INNER JOIN 
    energy.contracts ct ON ct.client_id = c.id
INNER JOIN 
    energy.readings r ON r.contract_id = ct.id
WHERE 
    ct.enabled = TRUE
    AND r.reading_date >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY 
    c.id, c.name
ORDER BY 
    consumption_in_kwh DESC;