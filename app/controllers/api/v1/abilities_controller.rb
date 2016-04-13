class Api::V1::AbilitiesController < Api::V1::ApiController

  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/abilities
  def index
    @abilities = Ability.all
  end
end
