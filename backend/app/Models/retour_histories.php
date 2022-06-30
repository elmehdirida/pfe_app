<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class retour_histories extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable =[
        'id',
        'ref',
        'retour_ref',
    ];
}