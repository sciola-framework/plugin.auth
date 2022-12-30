<?php

use Sciola\Route;

// http://localhost/route/of/your/system/auth=action
Route::add(base_route('/auth=(.*)'), function ($action) {
    controller('Auth')->init($action);
});
