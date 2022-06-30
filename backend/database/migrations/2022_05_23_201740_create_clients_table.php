<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateClientsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('clients', function (Blueprint $table) {
            $table->engine = "InnoDB";
            $table->id();
            $table->String('name');
            $table->integer('prix');
            $table->String('Adresse');
            $table->String('contact');
            $table->String('ice');
            $table->String('code');
            $table->String('username');
            $table->String('email');
            $table->String('password');
            $table->integer('active');
            $table->timestamp('created_at')->nullable();
            $table->timestamp('updated_at')->nullable();



        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('clients');
    }
}
