<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class att extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable =[
        'UserName',
        'contact',
        'Email',
        
    ];
}
