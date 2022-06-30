<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ClientController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProduitController;
use App\Http\Controllers\CommandeController;
use App\Http\Controllers\StockController;
use App\Http\Controllers\StockHestoriesController;
use App\Http\Controllers\SortieHestoriesController;
use App\Http\Controllers\SortieController;
use App\Http\Controllers\RetourHestoriesController;
use App\Http\Controllers\RetourController;
use App\Http\Controllers\AttController;





//Auth_Route
Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);

//att_route
Route::get('/att',[AttController::class,'index']);
Route::post('/att',[ClientController::class,'store']);
Route::DELETE('/att/{id}', [AttController::class,'destroy']);



//public_Client_Route
Route::get('/client',[ClientController::class,'index']);
Route::get('/client/search/{name}', [ClientController::class,'search']);
Route::get('/id/{email}', [ClientController::class,'id']);

Route::post('/client',[ClientController::class,'store']);
Route::post('/user',[ClientController::class,'adduser']);

Route::post('/client/{id}', [ClientController::class,'update']);



//protected route
Route::group(['middleware' => ['auth:sanctum']],function () {
Route::delete('/logout',[AuthController::class,'logout']);
Route::get('/user', function (Request $request) {
    return $request->user();   
});


});


//product route
Route::get('/produit',[ProduitController::class,'index']);
Route::get('/produit/{nom_produit}', [ProduitController::class,'search']);
Route::get('/user/produits/{id}', [ProduitController::class,'getForUser']);

Route::post('/produit',[ProduitController::class,'store']);
Route::post('/produit/{id}', [ProduitController::class,'update']);
Route::DELETE('/produit/{id}', [ProduitController::class,'destroy']);


//commande route
Route::get('/commande',[CommandeController::class,'index']);
Route::get('/commande/{name}', [CommandeController::class,'search']);
Route::post('/commande',[CommandeController::class,'store']);
Route::post('/commande/{id}', [CommandeController::class,'update']);
Route::delete('/commande/{id}', [CommandeController::class,'destroy']);
Route::get('/user/commande/{id}', [CommandeController::class,'getForUser']);



//stock route
Route::get('/stock',[StockController::class,'index']);
Route::get('/stock/{id}',[StockController::class,'byid']);

Route::get('/stock/{ref_stock}', [StockController::class,'search']);
Route::post('/stock',[StockController::class,'store']);
Route::post('/stock/{id}', [StockController::class,'update']);
Route::delete('/stock/{id}', [StockController::class,'destroy']);


//stockhestorie route
Route::get('/stockhestorie/{id}',[StockHestoriesController::class,'index']);
Route::post('/stockhestorie',[StockHestoriesController::class,'store']);
Route::post('/stockhestorie/{id}', [StockHestoriesController::class,'update']);
Route::delete('/stockhestorie/{id}', [StockHestoriesController::class,'destroy']);

//sortie route 
Route::get('/sortie',[SortieController::class,'index']);
Route::post('/sortie',[SortieController::class,'store']);
Route::post('/sortie/{id}', [SortieController::class,'update']);
Route::get('/user/sortie/{id}', [SortieController::class,'getForUser']);
//sortiehestorie route 
Route::get('/sortiehestorie/{id}',[SortieHestoriesController::class,'index']);
Route::post('/sortiehestorie',[SortieHestoriesController::class,'store']);
Route::post('/sortiehestorie/{id}', [SortieHestoriesController::class,'update']);
Route::delete('/sortiehestorie/{id}', [SortieHestoriesController::class,'destroy']);



//retour route 
Route::get('/retour',[RetourController::class,'index']);
Route::post('/retour',[RetourController::class,'store']);
Route::post('/retour/{id}', [RetourController::class,'update']);
Route::get('/user/retour/{id}', [RetourController::class,'getForUser']);
//sortiehestorie route 
Route::get('/retourhestorie/{retour_ref}',[RetourHestoriesController::class,'index']);
Route::get('/retourhestorie',[RetourHestoriesController::class,'index2']);

Route::post('/retourhestorie',[RetourHestoriesController::class,'store']);
Route::post('/retourhestorie/{id}', [RetourHestoriesController::class,'update']);
Route::delete('/retourhestorie/{id}', [RetourHestoriesController::class,'destroy']); 