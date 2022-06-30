<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
class Produits extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable =[
        'client_id',
        'nom_produit',
        'code_produit',
        'quantite_res',
        
    ];

}
 