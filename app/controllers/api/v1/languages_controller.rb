class Api::V1::LanguagesController < Api::V1::ApiController

  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/languages
  def index
    @languages = Language.all
  end
end
