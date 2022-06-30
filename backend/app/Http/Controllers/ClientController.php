<?php

namespace App\Http\Controllers;
use App\Models\Client;
use App\Models\User;

use Illuminate\Http\Request;

class ClientController extends Controller
{ 
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Client::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
        'email'=>'unique:clients,email'] );
        $request['password']=bcrypt($request['password']);
            
       
        return Client::create($request->all());
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return Client::find($id);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        
        $client= Client::find($id);
        $client->update($request->all());
        return $client;
    }
    

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
       return Client::destroy($id);
    }
    /**
     * Search the specified resource from storage.
     *
     * @param  str  $name
     * @return \Illuminate\Http\Response
     */
    public function search($name)
    {
      return  Client::where('name', 'like','%'.$name.'%')->get();
    }
    /**
     * Search the specified resource from storage.
     *
     * @param  str  $name
     * @return \Illuminate\Http\Response
     */
    public function id($email)
    {
      return  Client::where('email', 'like','%'.$email.'%')->get();
    }



    public function adduser( Request $request)
    {
        $fields = $request->validate(
            [
                'name'=> 'required|string',
                'email'=>'required|string|unique:users,email',
                'password'=>'required|string',
                'username'=>'required',
                'type'=>'required',
                ]
               
        );
        $user =User::create([
            'name'=> $fields['name'],
            'email'=> $fields['email'],
            'password'=> bcrypt($fields['password']),
            'username'=> $fields['username'],    
            'type'=>$fields['type'],             
        
        ]);
        $response=[
            'user'=>$user,
        ];
        return response($response,201);
    }
    
}
