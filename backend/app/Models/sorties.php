<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class sorties extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable =[
        'client_id',
        'ref_sortie',	
        'nbr_commande',
        'etat_bs',
    	'facture_id',
        'name_societe',
    ];
}
