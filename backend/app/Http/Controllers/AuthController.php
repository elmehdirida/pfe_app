<?php

namespace App\Http\Controllers;
use App\Models\Client;
use App\Models\Att;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;


class AuthController extends Controller
{
    public function register( Request $request)
    {
        $fields = $request->validate(
            [
                'UserName'=> 'required|string',
                'Email'=>'required|string|unique:clients,email',
                'contact'=>'required',
                ]
               
        );
        $user =Att::create([
            'UserName'=> $fields['UserName'],
            'Email'=> $fields['Email'],
            'contact'=> $fields['contact'],                 
        
        ]);
        $response=[
            'user'=>$user,
        ];
        return response($response,201);
    }

    public function login(Request $request) {
        $fields = $request->validate([
            'email' => 'required|string',
            'password' => 'required|string'
        ]);


        // Check email
        $user = User::where('email', $fields['email'])->first();

        // Check password
        if(!$user || !Hash::check($fields['password'], $user->password)) {
            return response([
                'message' => 'Bad creds'
            ], 401);
        }

        $token = $user->createToken('myapptoken')->plainTextToken;

        $response = [
            'token' => $token
        ];

        return response($response, 201);
    }


    public function logout(Request $request) {
        auth()->user()->tokens()->delete();

        return [
            'message' => 'Logged out'
        ];
    }
}
