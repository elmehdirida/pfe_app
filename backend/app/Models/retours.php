<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class retours extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable =[
        'id',
        'client_id',
        'ref_retour',	
        'name_societe',
    ];
}
