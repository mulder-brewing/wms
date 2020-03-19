

module Geography

  COUNTRIES = {
    'US' => 'United States',
    'CA' => 'Canada',
    'MX' => 'Mexico'
  }

  module States

    US = {
      'AL' => 'Alabama',
      'AK' => 'Alaska',
      'AZ' => 'Arizona',
      'AR' => 'Arkansas',
      'CA' => 'California',
      'CO' => 'Colorado',
      'CT' => 'Connecticut',
      'DE' => 'Delaware',
      'DC' => 'District of Columbia',
      'FL' => 'Florida',
      'GA' => 'Georgia',
      'HI' => 'Hawaii',
      'ID' => 'Idaho',
      'IL' => 'Illinois',
      'IN' => 'Indiana',
      'IA' => 'Iowa',
      'KS' => 'Kansas',
      'KY' => 'Kentucky',
      'LA' => 'Louisiana',
      'ME' => 'Maine',
      'MD' => 'Maryland',
      'MA' => 'Massachusetts',
      'MI' => 'Michigan',
      'MN' => 'Minnesota',
      'MS' => 'Mississippi',
      'MO' => 'Missouri',
      'MT' => 'Montana',
      'NE' => 'Nebraska',
      'NV' => 'Nevada',
      'NH' => 'New Hampshire',
      'NJ' => 'New Jersey',
      'NM' => 'New Mexico',
      'NY' => 'New York',
      'NC' => 'North Carolina',
      'ND' => 'North Dakota',
      'OH' => 'Ohio',
      'OK' => 'Oklahoma',
      'OR' => 'Oregon',
      'PA' => 'Pennsylvania',
      'PR' => 'Puerto Rico',
      'RI' => 'Rhode Island',
      'SC' => 'South Carolina',
      'SD' => 'South Dakota',
      'TN' => 'Tennessee',
      'TX' => 'Texas',
      'UT' => 'Utah',
      'VT' => 'Vermont',
      'VA' => 'Virginia',
      'WA' => 'Washington',
      'WV' => 'West Virginia',
      'WI' => 'Wisconsin',
      'WY' => 'Wyoming'
    }

    CA = {
      'AB' => 'Alberta',
      'BC' => 'British Columbia',
      'MB' => 'Manitoba',
      'NB' => 'New Brunswick',
      'NL' => 'Newfoundland and Labrador',
      'NS' => 'Nova Scotia',
      'NT' => 'Northwest Territories',
      'NU' => 'Nunavut',
      'ON' => 'Ontario',
      'PE' => 'Prince Edward Island',
      'QC' => 'Quebec',
      'SK' => 'Saskatchewan',
      'YT' => 'Yukon'
    }

    MX = {
      'AGS' => 'Aguascalientes',
      'BCN' => 'Baja California',
      'BCS' => 'Baja California Sur',
      'CAM' => 'Campeche',
      'CHP' => 'Chiapas',
      'CHI' => 'Chihuahua',
      'COA' => 'Coahuila',
      'COL' => 'Colima',
      'DIF' => 'Distrito Federal',
      'DUR' => 'Durango',
      'GTO' => 'Guanajuato',
      'GRO' => 'Guerrero',
      'HGO' => 'Hidalgo',
      'JAL' => 'Jalisco',
      'MEX' => 'México',
      'MIC' => 'Michoacán',
      'MOR' => 'Morelos',
      'NAY' => 'Nayarit',
      'NLE' => 'Nuevo León',
      'OAX' => 'Oaxaca',
      'PUE' => 'Puebla',
      'QRO' => 'Querétaro',
      'ROO' => 'Quintana Roo',
      'SLP' => 'San Luis Potosí',
      'SIN' => 'Sinaloa',
      'SON' => 'Sonora',
      'TAB' => 'Tabasco',
      'TAM' => 'Tamaulipas',
      'TLX' => 'Tlaxcala',
      'VER' => 'Veracruz',
      'YUC' => 'Yucatán',
      'ZAC' => 'Zacatecas'
    }

  end

  COUNTRIES_STATES = {
    'US' => States::US,
    'CA' => States::CA,
    'MX' => States::MX
  }

  def self.states_for_country(country_code)
    COUNTRIES_STATES[country_code]
  end

end
