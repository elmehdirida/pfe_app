<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSortieHistoriesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('sortie_histories', function (Blueprint $table) {
            $table->engine = "InnoDB";
            $table->id();
            $table->integer('produit_id');
            $table->String('produit_name');
            $table->String('produit_code');
            $table->integer('produit_entrer');
            $table->integer('sortie_id');
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
        Schema::dropIfExists('sortie_histories');
    }
}
