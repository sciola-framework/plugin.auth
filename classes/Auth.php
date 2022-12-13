<?php
/**
 * Authentication
 *
 * @version 1.0.2
 */
class Auth
{
    /**
     * group
     *
     * @param string $roles
     * @param callable $callback
     * @return mixed
     * @access public
     */
    public static function group($roles, $callback)
    {
        return Sciola\Layer::controller('Auth')->group($roles, $callback);
    }
}
