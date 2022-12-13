<?php
/**
 * Auth
 *
 * @version 1.0.0
 */
namespace Layers\Models;

use Framework\Settings;
use Framework\Model;
use Framework\Connection;
use \PDO;

class Auth extends Model
{
    private $pdo = null;

    /**
     * __construct
     *
     * @access public
     */
    public function __construct()
    {
        $this->pdo = Connection::pdo();
        if (CONSTANT['DEV_MODE']) {
            try {
                $table = $this->pdo->query('SELECT 1 FROM users LIMIT 1');
                if (!$table) {
                    $this->executeSQL();
                }
            } catch (\PDOException $e) {
                $this->executeSQL();
            }
        }
    }

    /**
     * executeSQL
     *
     * @access private
     */
    private function executeSQL()
    {
        $driver = strtolower($this->pdo->getAttribute(PDO::ATTR_DRIVER_NAME));
        $path   = PATH . '/database/sql';
        switch ($driver) {
          case 'mysql':
            $this->pdo->exec(file_get_contents("$path/MySQL.sql"));
            break;
          case 'pgsql':
            $this->pdo->exec(file_get_contents("$path/PostgreSQL.sql"));
            break;
          case 'sqlite':
            $this->pdo->exec(file_get_contents("$path/SQLite.sql"));
            break;
        }
    }

    /**
     * connection
     *
     * @return mixed
     * @access public
     */
    public function connection()
    {
        return $this->pdo;
    }

    /**
     * select
     *
     * @param string $query
     * @return mixed
     * @access public
     */
    public function select($query = '')
    {
        $query = $query ? "WHERE username LIKE '%{$query}%'" : '';
        $stmt  = $this->pdo->prepare("SELECT id,
                                             username,
                                             email,
                                             verified,
                                             status
                                      FROM   users $query");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /**
     * update
     *
     * @param int $id
     * @param string $data
     * @param string $field
     * @return bool
     * @access public
     */
    public function update($id, $data, $field)
    {
        $stmt = $this->pdo->prepare("UPDATE users
                                     SET    $field=?
                                     WHERE  id=?");
        if ($stmt->execute([$data, $id])) {
            return true;
        } else {
            return false;
        }
    }
}
