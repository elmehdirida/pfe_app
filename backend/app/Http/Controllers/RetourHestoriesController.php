<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\retour_histories;


class RetourHestoriesController extends Controller
{
   /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($ref)
    {
        return retour_histories::where('retour_ref', '=',$ref)->get();
    }
    public function index2()
    {
        return retour_histories::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {    
        return retour_histories::create($request->all());
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return retour_histories::find($id);
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
        
        $retour_historie= retour_histories::find($id);
        $retour_historie->update($request->all());
        return $retour_histories;
    }
    

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
       return retour_histories::destroy($id);
    }
  

}
