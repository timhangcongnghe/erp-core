module Erp
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable
		belongs_to :user_group, optional: true
    mount_uploader :avatar, Erp::AvatarUploader
    validates :name, :presence => true
    validates_format_of :email, :presence => true,
												:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
												:message => " is invalid (Eg. 'username@globalnaturesoft.com')"
    # validates :password, :length => { :minimum => 6, :maximum => 40 }, :confirmation => true

    belongs_to :creator, class_name: "Erp::User", optional: true
    belongs_to :user_group, class_name: "Erp::UserGroup", optional: true

    if Erp::Core.available?("contacts")
			has_one :contact, class_name: "Erp::Contacts::Contact", foreign_key: 'user_id'
			def contact_name
        contact.present? ? contact.contact_name : nil
      end
		end
    
    if Erp::Core.available?("finances")
      has_many :service_registers, class_name: "Erp::Finances::ServiceRegister", foreign_key: 'user_id', dependent: :destroy
    end

    if Erp::Core.available?("carts")
			has_many :wish_lists, dependent: :destroy, class_name: 'Erp::Carts::WishList'
		end

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      # filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      
      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(erp_users.cache_search) LIKE ?', '%'+q+'%')
				end
			end

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      # global filter
      global_filter = params[:global_filter]
      
      if global_filter.present?
				if global_filter[:user_group_id].present?
					query = query.where(user_group_id: global_filter[:user_group_id])
				end
			end
      # end// global filter

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      else
				query = query.order('erp_users.created_at DESC')
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(erp_users.cache_search) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|user| {value: user.id, text: user.name} }
    end
    
    # Update cache search
    after_save :update_cache_search
		def update_cache_search
			str = []
			str << email.to_s.downcase.strip
			str << name.to_s.downcase.strip

			self.update_column(:cache_search, str.join(" ") + " " + str.join(" ").to_ascii)
		end

    def activate
			update_columns(active: true, backend_access: true, confirmed_at: Time.now)
		end

    def deactivate
			update_columns(active: false)
		end

    def self.deactivate_all
			update_all(active: false)
		end

    def self.activate_all
			update_all(active: true)
		end

    def display_name
			self.name
		end

    def self.get_list_timezone
			mapping = {"Australia/Adelaide"=>"Adelaide", "Australia/Broken_Hill"=>"Adelaide", "America/Anchorage"=>"Alaska", "America/Juneau"=>"Alaska", "America/Nome"=>"Alaska", "America/Yakutat"=>"Alaska", "Pacific/Gambier"=>"Alaska", "Asia/Almaty"=>"Almaty", "Europe/Amsterdam"=>"Amsterdam", "Europe/Athens"=>"Athens", "America/Anguilla"=>"Atlantic Time (Canada)", "America/Antigua"=>"Atlantic Time (Canada)", "America/Argentina/San_Luis"=>"Atlantic Time (Canada)", "America/Aruba"=>"Atlantic Time (Canada)", "America/Asuncion"=>"Atlantic Time (Canada)", "America/Barbados"=>"Atlantic Time (Canada)", "America/Blanc-Sablon"=>"Atlantic Time (Canada)", "America/Boa_Vista"=>"Atlantic Time (Canada)", "America/Campo_Grande"=>"Atlantic Time (Canada)", "America/Cuiaba"=>"Atlantic Time (Canada)", "America/Curacao"=>"Atlantic Time (Canada)", "America/Dominica"=>"Atlantic Time (Canada)", "America/Eirunepe"=>"Atlantic Time (Canada)", "America/Glace_Bay"=>"Atlantic Time (Canada)", "America/Goose_Bay"=>"Atlantic Time (Canada)", "America/Grenada"=>"Atlantic Time (Canada)", "America/Guadeloupe"=>"Atlantic Time (Canada)", "America/Guyana"=>"Atlantic Time (Canada)", "America/Halifax"=>"Atlantic Time (Canada)", "America/Manaus"=>"Atlantic Time (Canada)", "America/Marigot"=>"Atlantic Time (Canada)", "America/Martinique"=>"Atlantic Time (Canada)", "America/Moncton"=>"Atlantic Time (Canada)", "America/Montserrat"=>"Atlantic Time (Canada)", "America/Porto_Velho"=>"Atlantic Time (Canada)", "America/Port_of_Spain"=>"Atlantic Time (Canada)", "America/Puerto_Rico"=>"Atlantic Time (Canada)", "America/Rio_Branco"=>"Atlantic Time (Canada)", "America/Santo_Domingo"=>"Atlantic Time (Canada)", "America/St_Barthelemy"=>"Atlantic Time (Canada)", "America/St_Kitts"=>"Atlantic Time (Canada)", "America/St_Lucia"=>"Atlantic Time (Canada)", "America/St_Thomas"=>"Atlantic Time (Canada)", "America/St_Vincent"=>"Atlantic Time (Canada)", "America/Thule"=>"Atlantic Time (Canada)", "America/Tortola"=>"Atlantic Time (Canada)", "Antarctica/Palmer"=>"Atlantic Time (Canada)", "Atlantic/Bermuda"=>"Atlantic Time (Canada)", "Atlantic/Stanley"=>"Atlantic Time (Canada)", "Antarctica/McMurdo"=>"Auckland", "Antarctica/South_Pole"=>"Auckland", "Pacific/Auckland"=>"Auckland", "Pacific/Funafuti"=>"Auckland", "Pacific/Kwajalein"=>"Auckland", "Pacific/Majuro"=>"Auckland", "Pacific/Nauru"=>"Auckland", "Pacific/Tarawa"=>"Auckland", "Pacific/Wake"=>"Auckland", "Pacific/Wallis"=>"Auckland", "Atlantic/Azores"=>"Azores", "Asia/Baghdad"=>"Baghdad", "Asia/Baku"=>"Baku", "Asia/Dubai"=>"Baku", "Indian/Mahe"=>"Baku", "Indian/Mauritius"=>"Baku", "Indian/Reunion"=>"Baku", "Asia/Bangkok"=>"Bangkok", "Europe/Belgrade"=>"Belgrade", "Europe/Berlin"=>"Berlin", "America/Bogota"=>"Bogota", "Europe/Bratislava"=>"Bratislava", "Australia/Brisbane"=>"Brisbane", "Europe/Brussels"=>"Brussels", "Europe/Bucharest"=>"Bucharest", "Europe/Budapest"=>"Budapest", "America/Araguaina"=>"Buenos Aires", "America/Argentina/Buenos_Aires"=>"Buenos Aires", "America/Argentina/Catamarca"=>"Buenos Aires", "America/Argentina/Cordoba"=>"Buenos Aires", "America/Argentina/Jujuy"=>"Buenos Aires", "America/Argentina/La_Rioja"=>"Buenos Aires", "America/Argentina/Mendoza"=>"Buenos Aires", "America/Argentina/Rio_Gallegos"=>"Buenos Aires", "America/Argentina/Salta"=>"Buenos Aires", "America/Argentina/San_Juan"=>"Buenos Aires", "America/Argentina/Tucuman"=>"Buenos Aires", "America/Argentina/Ushuaia"=>"Buenos Aires", "America/Bahia"=>"Buenos Aires", "America/Belem"=>"Buenos Aires", "America/Cayenne"=>"Buenos Aires", "America/Fortaleza"=>"Buenos Aires", "America/Godthab"=>"Buenos Aires", "America/Maceio"=>"Buenos Aires", "America/Miquelon"=>"Buenos Aires", "America/Montevideo"=>"Buenos Aires", "America/Paramaribo"=>"Buenos Aires", "America/Recife"=>"Buenos Aires", "America/Santarem"=>"Buenos Aires", "America/Sao_Paulo"=>"Buenos Aires", "Antarctica/Rothera"=>"Buenos Aires", "Africa/Blantyre"=>"Cairo", "Africa/Bujumbura"=>"Cairo", "Africa/Cairo"=>"Cairo", "Africa/Gaborone"=>"Cairo", "Africa/Johannesburg"=>"Cairo", "Africa/Kigali"=>"Cairo", "Africa/Lubumbashi"=>"Cairo", "Africa/Lusaka"=>"Cairo", "Africa/Maputo"=>"Cairo", "Africa/Maseru"=>"Cairo", "Africa/Mbabane"=>"Cairo", "Africa/Tripoli"=>"Cairo", "Asia/Amman"=>"Cairo", "Asia/Beirut"=>"Cairo", "Asia/Damascus"=>"Cairo", "Asia/Gaza"=>"Cairo", "Asia/Nicosia"=>"Cairo", "Europe/Chisinau"=>"Cairo", "Europe/Kaliningrad"=>"Cairo", "Europe/Kiev"=>"Cairo", "Europe/Mariehamn"=>"Cairo", "Europe/Simferopol"=>"Cairo", "Europe/Uzhgorod"=>"Cairo", "Europe/Zaporozhye"=>"Cairo", "America/Scoresbysund"=>"Cape Verde Is.", "Atlantic/Cape_Verde"=>"Cape Verde Is.", "America/Caracas"=>"Caracas", "Africa/Casablanca"=>"Casablanca", "America/Belize"=>"Central Time (US & Canada)", "America/Cancun"=>"Central Time (US & Canada)", "America/Chicago"=>"Central Time (US & Canada)", "America/Costa_Rica"=>"Central Time (US & Canada)", "America/El_Salvador"=>"Central Time (US & Canada)", "America/Guatemala"=>"Central Time (US & Canada)", "America/Indiana/Knox"=>"Central Time (US & Canada)", "America/Indiana/Tell_City"=>"Central Time (US & Canada)", "America/Managua"=>"Central Time (US & Canada)", "America/Matamoros"=>"Central Time (US & Canada)", "America/Menominee"=>"Central Time (US & Canada)", "America/Merida"=>"Central Time (US & Canada)", "America/North_Dakota/Center"=>"Central Time (US & Canada)", "America/North_Dakota/New_Salem"=>"Central Time (US & Canada)", "America/Rainy_River"=>"Central Time (US & Canada)", "America/Rankin_Inlet"=>"Central Time (US & Canada)", "America/Regina"=>"Central Time (US & Canada)", "America/Swift_Current"=>"Central Time (US & Canada)", "America/Tegucigalpa"=>"Central Time (US & Canada)", "America/Winnipeg"=>"Central Time (US & Canada)", "Pacific/Easter"=>"Central Time (US & Canada)", "Pacific/Galapagos"=>"Central Time (US & Canada)", "America/Chihuahua"=>"Chihuahua", "Asia/Chongqing"=>"Chongqing", "Europe/Copenhagen"=>"Copenhagen", "Australia/Darwin"=>"Darwin", "Antarctica/Mawson"=>"Dhaka", "Asia/Bishkek"=>"Dhaka", "Asia/Dhaka"=>"Dhaka", "Asia/Karachi"=>"Dhaka", "Asia/Novokuznetsk"=>"Dhaka", "Asia/Omsk"=>"Dhaka", "Asia/Qyzylorda"=>"Dhaka", "Asia/Thimphu"=>"Dhaka", "Indian/Chagos"=>"Dhaka", "Europe/Dublin"=>"Dublin", "America/Atikokan"=>"Eastern Time (US & Canada)", "America/Cayman"=>"Eastern Time (US & Canada)", "America/Detroit"=>"Eastern Time (US & Canada)", "America/Grand_Turk"=>"Eastern Time (US & Canada)", "America/Guayaquil"=>"Eastern Time (US & Canada)", "America/Havana"=>"Eastern Time (US & Canada)", "America/Indiana/Indianapolis"=>"Eastern Time (US & Canada)", "America/Indiana/Marengo"=>"Eastern Time (US & Canada)", "America/Indiana/Petersburg"=>"Eastern Time (US & Canada)", "America/Indiana/Vevay"=>"Eastern Time (US & Canada)", "America/Indiana/Vincennes"=>"Eastern Time (US & Canada)", "America/Indiana/Winamac"=>"Eastern Time (US & Canada)", "America/Iqaluit"=>"Eastern Time (US & Canada)", "America/Jamaica"=>"Eastern Time (US & Canada)", "America/Kentucky/Louisville"=>"Eastern Time (US & Canada)", "America/Kentucky/Monticello"=>"Eastern Time (US & Canada)", "America/Montreal"=>"Eastern Time (US & Canada)", "America/Nassau"=>"Eastern Time (US & Canada)", "America/New_York"=>"Eastern Time (US & Canada)", "America/Nipigon"=>"Eastern Time (US & Canada)", "America/Panama"=>"Eastern Time (US & Canada)", "America/Pangnirtung"=>"Eastern Time (US & Canada)", "America/Port-au-Prince"=>"Eastern Time (US & Canada)", "America/Resolute"=>"Eastern Time (US & Canada)", "America/Thunder_Bay"=>"Eastern Time (US & Canada)", "America/Toronto"=>"Eastern Time (US & Canada)", "Pacific/Fiji"=>"Fiji", "Pacific/Guam"=>"Guam", "Africa/Harare"=>"Harare", "America/Adak"=>"Hawaii", "Pacific/Fakaofo"=>"Hawaii", "Pacific/Honolulu"=>"Hawaii", "Pacific/Johnston"=>"Hawaii", "Pacific/Rarotonga"=>"Hawaii", "Pacific/Tahiti"=>"Hawaii", "Europe/Helsinki"=>"Helsinki", "Australia/Hobart"=>"Hobart", "Antarctica/Casey"=>"Hong Kong", "Asia/Brunei"=>"Hong Kong", "Asia/Choibalsan"=>"Hong Kong", "Asia/Harbin"=>"Hong Kong", "Asia/Hong_Kong"=>"Hong Kong", "Asia/Kashgar"=>"Hong Kong", "Asia/Kuching"=>"Hong Kong", "Asia/Macau"=>"Hong Kong", "Asia/Makassar"=>"Hong Kong", "Asia/Manila"=>"Hong Kong", "Asia/Shanghai"=>"Hong Kong", "Asia/Ulaanbaatar"=>"Hong Kong", "Asia/Irkutsk"=>"Irkutsk", "Europe/Istanbul"=>"Istanbul", "Antarctica/Davis"=>"Jakarta", "Asia/Hovd"=>"Jakarta", "Asia/Hanoi"=>"Jakarta", "Asia/Jakarta"=>"Jakarta", "Asia/Phnom_Penh"=>"Jakarta", "Asia/Pontianak"=>"Jakarta", "Asia/Vientiane"=>"Jakarta", "Indian/Christmas"=>"Jakarta", "Asia/Jerusalem"=>"Jerusalem", "Asia/Kabul"=>"Kabul", "Asia/Kamchatka"=>"Kamchatka", "Asia/Aqtau"=>"Karachi", "Asia/Aqtobe"=>"Karachi", "Asia/Ashgabat"=>"Karachi", "Asia/Dushanbe"=>"Karachi", "Asia/Oral"=>"Karachi", "Asia/Samarkand"=>"Karachi", "Asia/Yekaterinburg"=>"Karachi", "Indian/Kerguelen"=>"Karachi", "Indian/Maldives"=>"Karachi", "Asia/Kathmandu"=>"Kathmandu", "Asia/Kolkata"=>"Kolkata", "Asia/Krasnoyarsk"=>"Krasnoyarsk", "Asia/Kuala_Lumpur"=>"Kuala Lumpur", "Asia/Kuwait"=>"Kuwait", "America/La_Paz"=>"La Paz", "America/Lima"=>"Lima", "Europe/Lisbon"=>"Lisbon", "Europe/Ljubljana"=>"Ljubljana", "Africa/Abidjan"=>"London", "Africa/Accra"=>"London", "Africa/Bamako"=>"London", "Africa/Banjul"=>"London", "Africa/Bissau"=>"London", "Africa/Conakry"=>"London", "Africa/Dakar"=>"London", "Africa/El_Aaiun"=>"London", "Africa/Freetown"=>"London", "Africa/Lome"=>"London", "Africa/Nouakchott"=>"London", "Africa/Ouagadougou"=>"London", "Africa/Sao_Tome"=>"London", "America/Danmarkshavn"=>"London", "Antarctica/Vostok"=>"London", "Atlantic/Canary"=>"London", "Atlantic/Faroe"=>"London", "Atlantic/Madeira"=>"London", "Atlantic/Reykjavik"=>"London", "Atlantic/St_Helena"=>"London", "Europe/Guernsey"=>"London", "Europe/Isle_of_Man"=>"London", "Europe/Jersey"=>"London", "Europe/London"=>"London", "Europe/Madrid"=>"Madrid", "Asia/Magadan"=>"Magadan", "America/Mazatlan"=>"Mazatlan", "Australia/Melbourne"=>"Melbourne", "America/Mexico_City"=>"Mexico City", "America/Noronha"=>"Mid-Atlantic", "Atlantic/South_Georgia"=>"Mid-Atlantic", "Europe/Minsk"=>"Minsk", "Africa/Monrovia"=>"Monrovia", "America/Monterrey"=>"Monterrey", "Africa/Addis_Ababa"=>"Moscow", "Africa/Asmara"=>"Moscow", "Africa/Dar_es_Salaam"=>"Moscow", "Africa/Djibouti"=>"Moscow", "Africa/Kampala"=>"Moscow", "Africa/Khartoum"=>"Moscow", "Africa/Mogadishu"=>"Moscow", "Antarctica/Syowa"=>"Moscow", "Asia/Aden"=>"Moscow", "Asia/Bahrain"=>"Moscow", "Asia/Qatar"=>"Moscow", "Europe/Moscow"=>"Moscow", "Europe/Samara"=>"Moscow", "Indian/Antananarivo"=>"Moscow", "Indian/Comoro"=>"Moscow", "Indian/Mayotte"=>"Moscow", "America/Boise"=>"Mountain Time (US & Canada)", "America/Cambridge_Bay"=>"Mountain Time (US & Canada)", "America/Dawson_Creek"=>"Mountain Time (US & Canada)", "America/Denver"=>"Mountain Time (US & Canada)", "America/Edmonton"=>"Mountain Time (US & Canada)", "America/Hermosillo"=>"Mountain Time (US & Canada)", "America/Inuvik"=>"Mountain Time (US & Canada)", "America/Ojinaga"=>"Mountain Time (US & Canada)", "America/Phoenix"=>"Mountain Time (US & Canada)", "America/Shiprock"=>"Mountain Time (US & Canada)", "America/Yellowknife"=>"Mountain Time (US & Canada)", "Asia/Colombo"=>"Mumbai", "Asia/Muscat"=>"Muscat", "Africa/Nairobi"=>"Nairobi", "America/St_Johns"=>"Newfoundland", "Asia/Novosibirsk"=>"Novosibirsk", "Pacific/Enderbury"=>"Nuku'alofa", "Pacific/Tongatapu"=>"Nuku'alofa", "America/Dawson"=>"Pacific Time (US & Canada)", "America/Los_Angeles"=>"Pacific Time (US & Canada)", "America/Santa_Isabel"=>"Pacific Time (US & Canada)", "America/Vancouver"=>"Pacific Time (US & Canada)", "America/Whitehorse"=>"Pacific Time (US & Canada)", "Pacific/Pitcairn"=>"Pacific Time (US & Canada)", "Africa/Algiers"=>"Paris", "Africa/Bangui"=>"Paris", "Africa/Brazzaville"=>"Paris", "Africa/Ceuta"=>"Paris", "Africa/Douala"=>"Paris", "Africa/Kinshasa"=>"Paris", "Africa/Lagos"=>"Paris", "Africa/Libreville"=>"Paris", "Africa/Luanda"=>"Paris", "Africa/Malabo"=>"Paris", "Africa/Ndjamena"=>"Paris", "Africa/Niamey"=>"Paris", "Africa/Porto-Novo"=>"Paris", "Africa/Tunis"=>"Paris", "Africa/Windhoek"=>"Paris", "Arctic/Longyearbyen"=>"Paris", "Europe/Andorra"=>"Paris", "Europe/Gibraltar"=>"Paris", "Europe/Luxembourg"=>"Paris", "Europe/Malta"=>"Paris", "Europe/Monaco"=>"Paris", "Europe/Oslo"=>"Paris", "Europe/Paris"=>"Paris", "Europe/Podgorica"=>"Paris", "Europe/San_Marino"=>"Paris", "Europe/Tirane"=>"Paris", "Europe/Vaduz"=>"Paris", "Europe/Vatican"=>"Paris", "Europe/Zurich"=>"Paris", "Australia/Perth"=>"Perth", "Pacific/Port_Moresby"=>"Port Moresby", "Europe/Prague"=>"Prague", "Asia/Rangoon"=>"Rangoon", "Indian/Cocos"=>"Rangoon", "Europe/Riga"=>"Riga", "Asia/Riyadh"=>"Riyadh", "Europe/Rome"=>"Rome", "Pacific/Apia"=>"Samoa", "Pacific/Midway"=>"Samoa", "Pacific/Niue"=>"Samoa", "Pacific/Pago_Pago"=>"Samoa", "America/Santiago"=>"Santiago", "Europe/Sarajevo"=>"Sarajevo", "Asia/Seoul"=>"Seoul", "Asia/Singapore"=>"Singapore", "Europe/Skopje"=>"Skopje", "Europe/Sofia"=>"Sofia", "Asia/Anadyr"=>"Solomon Is.", "Pacific/Efate"=>"Solomon Is.", "Pacific/Guadalcanal"=>"Solomon Is.", "Pacific/Kosrae"=>"Solomon Is.", "Pacific/Noumea"=>"Solomon Is.", "Pacific/Ponape"=>"Solomon Is.", "Europe/Stockholm"=>"Stockholm", "Antarctica/DumontDUrville"=>"Sydney", "Asia/Sakhalin"=>"Sydney", "Australia/Currie"=>"Sydney", "Australia/Lindeman"=>"Sydney", "Australia/Sydney"=>"Sydney", "Pacific/Saipan"=>"Sydney", "Pacific/Truk"=>"Sydney", "Asia/Taipei"=>"Taipei", "Europe/Tallinn"=>"Tallinn", "Asia/Tashkent"=>"Tashkent", "Asia/Tbilisi"=>"Tbilisi", "Asia/Tehran"=>"Tehran", "America/Tijuana"=>"Tijuana", "Asia/Dili"=>"Tokyo", "Asia/Jayapura"=>"Tokyo", "Asia/Pyongyang"=>"Tokyo", "Asia/Tokyo"=>"Tokyo", "Pacific/Palau"=>"Tokyo", "Asia/Urumqi"=>"Urumqi", "Europe/Vienna"=>"Vienna", "Europe/Vilnius"=>"Vilnius", "Asia/Vladivostok"=>"Vladivostok", "Europe/Volgograd"=>"Volgograd", "Europe/Warsaw"=>"Warsaw", "Asia/Yakutsk"=>"Yakutsk", "Asia/Yerevan"=>"Yerevan", "Europe/Zagreb"=>"Zagreb"}
			timezones = []
			mapping.each do |t|
				timezones << {text: t[0], value: t[0]}
			end
			return timezones
    end

    def self.create_with_omniauth(auth)
			user = User.new ({
				provider: auth["provider"],
				uid: auth["uid"],
				name: auth["info"]["name"],
				email: auth["info"]["email"].present? ? auth["info"]["email"] : "#{(0...50).map { ('a'..'z').to_a[rand(26)]}.join}@unknown.com",
				password: 'aA456321@',
			})
			user.skip_confirmation!
			user.save
			return user
		end

    def self.permission_options
			{
				"products_comments" => {
					"create" => {
						"default" => "yes",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					},
					"delete" => {
						"default" => "no",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					}
				},
				"products_ratings" => {
					"create" => {
						"default" => "yes",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					},
					"delete" => {
						"default" => "no",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					}
				},
				"articles_comments" => {
					"create" => {
						"default" => "yes",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					},
					"delete" => {
						"default" => "no",
						"type" => "checkbox",
						"options" => ["no", "yes"]
					}
				},
			}
		end

    # old permissions
    def get_permissions
			saved_permissions = {}
			saved_permissions = JSON.parse(self.permissions) if self.permissions.present?

			permissions = {}
			permission_options = User.permission_options
			permission_options.each do |group|
				permissions[group[0]] = {}
				group[1].each do |per|
					if saved_permissions[group[0]].present? and saved_permissions[group[0]][per[0]].present?
						permissions[group[0]][per[0]] = saved_permissions[group[0]][per[0]]
					else
						permissions[group[0]][per[0]] = per[1]["default"]
					end
				end
			end

			permissions
		end

    def user_group_name
			user_group.present? ? user_group.name : ''
		end

    # new permission from group
    def get_permission(group, engine, controller, permission)
      return 'yes' if user_group.nil?
      return user_group.get_permissions[group][engine][controller][permission][:value]
    end

    # empoyee count
    def self.employee_count
      self.count-1
    end

    # get data
    def get_data
      return {} if !self.data.present?
      JSON.parse(self.data)
    end

    # get filters
    def get_filters(url=nil)
      data = self.get_data
      return {} if !data["filters"].present?

      if url.present?
        return data["filters"][url].present? ? data["filters"][url] : {}
      else
        return data["filters"]
      end
    end

    # update filter
    def update_filter(url, params)
      data = self.get_data

      if data["filters"].present?
        data["filters"][url] = params
      else
        data["filters"] = {}
        data["filters"][url] = params
      end

      self.update_column(:data, data.to_json)
    end
  end
end
