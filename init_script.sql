DELIMITER $$
DROP PROCEDURE IF EXISTS init_script $$
CREATE PROCEDURE init_script()
BEGIN
	START TRANSACTION;

	-- part one (employee table)
	CREATE TABLE IF NOT EXISTS employees (
		id SMALLINT AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		salary INT UNSIGNED NOT NULL,
		national_insurance_number VARCHAR(9) NOT NULL
	);

	-- part two (access table)

	CREATE TABLE IF NOT EXISTS access (
		id SMALLINT AUTO_INCREMENT PRIMARY KEY,
		employee_id SMALLINT NOT NULL,
		role ENUM('hr', 'management', 'delivery') NOT NULL,
		FOREIGN KEY (employee_id) REFERENCES employees(id)
	);

	-- part three (client table)

	CREATE TABLE IF NOT EXISTS clients (
		id SMALLINT AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		address VARCHAR(255) NOT NULL,
		phone VARCHAR(11) NOT NULL,
		FOREIGN KEY (lead_employee_id) REFERENCES employees(id)
	);

		
	CREATE TABLE IF NOT EXISTS projects (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	client_id SMALLINT UNSIGNED NOT NULL,
	name VARCHAR(50) NOT NULL,
	value INT UNSIGNED NOT NULL,
	technologies TEXT,
	started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	completed_at TIMESTAMP,

	FOREIGN KEY (client_id) REFERENCES client(id)
	);        
			
	CREATE TABLE IF NOT EXISTS project_employees (
	project_id SMALLINT UNSIGNED NOT NULL,
	client_id SMALLINT UNSIGNED NOT NULL,
	joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT pk_project_client PRIMARY KEY (project_id, client_id),
	FOREIGN KEY (project_id) REFERENCES projects(id),
	FOREIGN KEY (client_id) REFERENCES client(id)
	);     
			
	CREATE TABLE IF NOT EXISTS project_employee_logs (
	project_id SMALLINT UNSIGNED NOT NULL,
	client_id SMALLINT UNSIGNED NOT NULL,
	joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	left_at TIMESTAMP,

	CONSTRAINT pk_project_client PRIMARY KEY (project_id, client_id),
	FOREIGN KEY (project_id) REFERENCES project(id),
	FOREIGN KEY (client_id) REFERENCES client(id)
	);       

	-- check the number of affected rows
	GET DIAGNOSTICS @rows = ROW_COUNT;
	IF @rows = 0 THEN
		-- Rollback if error
		ROLLBACK;
		SELECT 'Transaction rolled back due to an error.';
	ELSE
		-- If error free
		COMMIT;
		SELECT 'Transaction committed successfully.';
	END IF; 
	
END $$
DELIMITER ;
CALL init_script();			