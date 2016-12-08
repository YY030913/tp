/* globals Template, emojione */

var emojisByCategory;
var toneList;

/*
 * Mapping category hashes into human readable and translated names
 */
var emojiCategories = {
	recent: TAPi18n.__('Frequently_Used'),
	people: TAPi18n.__('Smileys_and_People'),
	nature: TAPi18n.__('Animals_and_Nature'),
	food: TAPi18n.__('Food_and_Drink'),
	activity: TAPi18n.__('Activity'),
	travel: TAPi18n.__('Travel_and_Places'),
	objects: TAPi18n.__('Objects'),
	symbols: TAPi18n.__('Symbols'),
	flags: TAPi18n.__('Flags')
};

/**
 * Turns category hash to a nice readable translated name
 * @param {string} category hash
 * @return {string} readable and translated
 */
function categoryName(category) {
	if (emojiCategories[category]) {
		return emojiCategories[category];
	}
	// unknown category; better hash than nothing
	return category;
}

function getEmojisByCategory(category) {
	const t = Template.instance();
	const total = emojisByCategory[category].length;
	let html = '';
	const actualTone = t.tone;
	for (var i = 0; i < total; i++) {
		let emoji = emojisByCategory[category][i];
		let tone = '';

		if (actualTone > 0 && toneList.hasOwnProperty(emoji)) {
			tone = '_tone' + actualTone;
		}

		const image = emojione.toImage(':' + emoji + tone + ':');

		html += `<li class="emoji-${emoji}" data-emoji="${emoji}" title="${emoji}">${image}</li>`;
	}
	return html;
}

function getEmojisBySearchTerm(searchTerm) {
	let html = '';
	const actualTone = t.tone;

	for (let category of Object.keys(emojisByCategory)) {
		if (category !== 'recent') {
			for (let emoji of emojisByCategory[category]) {
				if (emoji.indexOf(searchTerm.toLowerCase()) > -1) {
					let tone = '';

					if (actualTone > 0 && toneList.hasOwnProperty(emoji)) {
						tone = '_tone' + actualTone;
					}

					const image = emojione.toImage(':' + emoji + tone + ':');

					html += `<li class="emoji-${emoji}" data-emoji="${emoji}" title="${emoji}">${image}</li>`;

				}
			}
		}
	}

	return html;
}

Template.emojiPicker.helpers({
	category() {
		return Object.keys(emojisByCategory);
	},
	emojiByCategory(category) {
		if (!emojisByCategory[category]) {
			return [];
		}
		return emojisByCategory[category];
	},
	isVisible(category) {
		return Template.instance().currentCategory.get() === category ? 'visible' : '';
	},
	emojiList(category) {
		const t = Template.instance();
		const searchTerm = t.currentSearchTerm.get();

		if (searchTerm.length > 0) {
			return getEmojisBySearchTerm(searchTerm);
		} else {
			return getEmojisByCategory(category);
		}

	},
	currentTone() {
		return 'tone-' + Template.instance().tone;
	},
	/**
	 * Returns true if a given emoji category is active
	 *
	 * @param {string} category hash
	 * @return {boolean} true if active, false otherwise
	 */
	activeCategory(category) {
		return Template.instance().currentCategory.get() === category ? 'active' : '';
	},
	categoryName: categoryName,
	/**
	 * Returns currently active emoji category hash
	 *
	 * @return {string} category hash
	 */
	currentCategory() {
		const t = Template.instance();
		const hash = t.currentCategory.get();
		const searchTerm = t.currentSearchTerm.get();

		if (searchTerm.length > 0) {
			return TAPi18n.__('Search');
		} else {
			return categoryName(hash);
		}
	}
});

Template.emojiPicker.events({
	'click .emoji-picker'(event) {
		event.stopPropagation();
		event.preventDefault();
	},
	'click .category-link'(event, instance) {
		event.stopPropagation();
		event.preventDefault();

		instance.currentCategory.set(event.currentTarget.hash.substr(1));

		return false;
	},
	'click .change-tone > a'(event, instance) {
		event.stopPropagation();
		event.preventDefault();

		instance.$('.tone-selector').toggleClass('show');
	},
	'click .tone-selector .tone'(event, instance) {
		event.stopPropagation();
		event.preventDefault();

		let tone = parseInt(event.currentTarget.dataset.tone);
		let newTone;

		if (tone > 0) {
			newTone = '_tone' + tone;
		} else {
			newTone = '';
		}

		for (var emoji in toneList) {
			if (toneList.hasOwnProperty(emoji)) {
				$('.emoji-'+emoji).html(emojione.toImage(':' + emoji + newTone + ':'));
			}
		}

		CaoLiao.EmojiPicker.setTone(tone);

		instance.setCurrentTone(tone);

		$('.tone-selector').toggleClass('show');
	},
	'click .emoji-list li'(event, instance) {
		event.stopPropagation();

		let emoji = event.currentTarget.dataset.emoji;
		let actualTone = instance.tone;
		let tone = '';

		if (actualTone > 0 && toneList.hasOwnProperty(emoji)) {
			tone = '_tone' + actualTone;
		}

		const input = $('.emoji-filter input.search');
		if (input) {
			input.val('');
		}
		instance.currentSearchTerm.set('');

		CaoLiao.EmojiPicker.pickEmoji(emoji + tone);
	},
	'keydown .emoji-filter .search'(event) {
		if (event.keyCode === 13) {
			event.preventDefault();
		}
	},
	'keyup .emoji-filter .search'(event, instance) {
		const value = event.target.value.trim();
		const cst = instance.currentSearchTerm;
		if (value === cst.get()) {
			return;
		}
		cst.set(value);
	}
});

Template.emojiPicker.onCreated(function() {
	this.tone = CaoLiao.EmojiPicker.getTone();
	let recent = CaoLiao.EmojiPicker.getRecent();

	this.currentCategory = new ReactiveVar(recent.length > 0 ? 'recent' : 'people');
	this.currentSearchTerm = new ReactiveVar('');

	recent.forEach((emoji) => {
		emojisByCategory.recent.push(emoji);
	});

	this.setCurrentTone = (newTone) => {
		$('.current-tone').removeClass('tone-' + this.tone);
		$('.current-tone').addClass('tone-' + newTone);
		this.tone = newTone;
	};
});

toneList = {
	'raised_hands': 1,
	'clap': 1,
	'wave': 1,
	'thumbsup': 1,
	'thumbsdown': 1,
	'punch': 1,
	'fist': 1,
	'v': 1,
	'ok_hand': 1,
	'raised_hand': 1,
	'open_hands': 1,
	'muscle': 1,
	'pray': 1,
	'point_up': 1,
	'point_up_2': 1,
	'point_down': 1,
	'point_left': 1,
	'point_right': 1,
	'middle_finger': 1,
	'hand_splayed': 1,
	'metal': 1,
	'vulcan': 1,
	'writing_hand': 1,
	'nail_care': 1,
	'ear': 1,
	'nose': 1,
	'baby': 1,
	'boy': 1,
	'girl': 1,
	'man': 1,
	'woman': 1,
	'person_with_blond_hair': 1,
	'older_man': 1,
	'older_woman': 1,
	'man_with_gua_pi_mao': 1,
	'man_with_turban': 1,
	'cop': 1,
	'construction_worker': 1,
	'guardsman': 1,
	'santa': 1,
	'angel': 1,
	'princess': 1,
	'bride_with_veil': 1,
	'walking': 1,
	'runner': 1,
	'dancer': 1,
	'bow': 1,
	'information_desk_person': 1,
	'no_good': 1,
	'ok_woman': 1,
	'raising_hand': 1,
	'person_with_pouting_face': 1,
	'person_frowning': 1,
	'haircut': 1,
	'massage': 1,
	'rowboat': 1,
	'swimmer': 1,
	'surfer': 1,
	'bath': 1,
	'basketball_player': 1,
	'lifter': 1,
	'bicyclist': 1,
	'mountain_bicyclist': 1,
	'horse_racing': 1,
	'spy': 1
};

emojisByCategory = {
	'recent': [],
	'people': [
		'grinning',
		'grimacing',
		'grin',
		'joy',
		'smiley',
		'smile',
		'sweat_smile',
		'laughing',
		'innocent',
		'wink',
		'blush',
		'slight_smile',
		'upside_down',
		'relaxed',
		'yum',
		'relieved',
		'heart_eyes',
		'kissing_heart',
		'kissing',
		'kissing_smiling_eyes',
		'kissing_closed_eyes',
		'stuck_out_tongue_winking_eye',
		'stuck_out_tongue_closed_eyes',
		'stuck_out_tongue',
		'money_mouth',
		'nerd',
		'sunglasses',
		'hugging',
		'smirk',
		'no_mouth',
		'neutral_face',
		'expressionless',
		'unamused',
		'rolling_eyes',
		'thinking',
		'flushed',
		'disappointed',
		'worried',
		'angry',
		'rage',
		'pensive',
		'confused',
		'slight_frown',
		'frowning2',
		'persevere',
		'confounded',
		'tired_face',
		'weary',
		'triumph',
		'open_mouth',
		'scream',
		'fearful',
		'cold_sweat',
		'hushed',
		'frowning',
		'anguished',
		'cry',
		'disappointed_relieved',
		'sleepy',
		'sweat',
		'sob',
		'dizzy_face',
		'astonished',
		'zipper_mouth',
		'mask',
		'thermometer_face',
		'head_bandage',
		'sleeping',
		'zzz',
		'poop',
		'smiling_imp',
		'imp',
		'japanese_ogre',
		'japanese_goblin',
		'skull',
		'ghost',
		'alien',
		'robot',
		'smiley_cat',
		'smile_cat',
		'joy_cat',
		'heart_eyes_cat',
		'smirk_cat',
		'kissing_cat',
		'scream_cat',
		'crying_cat_face',
		'pouting_cat',
		'raised_hands',
		'clap',
		'wave',
		'thumbsup',
		'thumbsdown',
		'punch',
		'fist',
		'v',
		'ok_hand',
		'raised_hand',
		'open_hands',
		'muscle',
		'pray',
		'point_up',
		'point_up_2',
		'point_down',
		'point_left',
		'point_right',
		'middle_finger',
		'hand_splayed',
		'metal',
		'vulcan',
		'writing_hand',
		'nail_care',
		'lips',
		'tongue',
		'ear',
		'nose',
		'eye',
		'eyes',
		'bust_in_silhouette',
		'busts_in_silhouette',
		'speaking_head',
		'baby',
		'boy',
		'girl',
		'man',
		'woman',
		'person_with_blond_hair',
		'older_man',
		'older_woman',
		'man_with_gua_pi_mao',
		'man_with_turban',
		'cop',
		'construction_worker',
		'guardsman',
		'spy',
		'santa',
		'angel',
		'princess',
		'bride_with_veil',
		'walking',
		'runner',
		'dancer',
		'dancers',
		'couple',
		'two_men_holding_hands',
		'two_women_holding_hands',
		'bow',
		'information_desk_person',
		'no_good',
		'ok_woman',
		'raising_hand',
		'person_with_pouting_face',
		'person_frowning',
		'haircut',
		'massage',
		'couple_with_heart',
		'couple_ww',
		'couple_mm',
		'couplekiss',
		'kiss_ww',
		'kiss_mm',
		'family',
		'family_mwg',
		'family_mwgb',
		'family_mwbb',
		'family_mwgg',
		'family_wwb',
		'family_wwg',
		'family_wwgb',
		'family_wwbb',
		'family_wwgg',
		'family_mmb',
		'family_mmg',
		'family_mmgb',
		'family_mmbb',
		'family_mmgg',
		'womans_clothes',
		'shirt',
		'jeans',
		'necktie',
		'dress',
		'bikini',
		'kimono',
		'lipstick',
		'kiss',
		'footprints',
		'high_heel',
		'sandal',
		'boot',
		'mans_shoe',
		'athletic_shoe',
		'womans_hat',
		'tophat',
		'helmet_with_cross',
		'mortar_board',
		'crown',
		'school_satchel',
		'pouch',
		'purse',
		'handbag',
		'briefcase',
		'eyeglasses',
		'dark_sunglasses',
		'ring',
		'closed_umbrella'
	]
	/*
	'nature': [
		'dog',
		'cat',
		'mouse',
		'hamster',
		'rabbit',
		'bear',
		'panda_face',
		'koala',
		'tiger',
		'lion_face',
		'cow',
		'pig',
		'pig_nose',
		'frog',
		'octopus',
		'monkey_face',
		'see_no_evil',
		'hear_no_evil',
		'speak_no_evil',
		'monkey',
		'chicken',
		'penguin',
		'bird',
		'baby_chick',
		'hatching_chick',
		'hatched_chick',
		'wolf',
		'boar',
		'horse',
		'unicorn',
		'bee',
		'bug',
		'snail',
		'beetle',
		'ant',
		'spider',
		'scorpion',
		'crab',
		'snake',
		'turtle',
		'tropical_fish',
		'fish',
		'blowfish',
		'dolphin',
		'whale',
		'whale2',
		'crocodile',
		'leopard',
		'tiger2',
		'water_buffalo',
		'ox',
		'cow2',
		'dromedary_camel',
		'camel',
		'elephant',
		'goat',
		'ram',
		'sheep',
		'racehorse',
		'pig2',
		'rat',
		'mouse2',
		'rooster',
		'turkey',
		'dove',
		'dog2',
		'poodle',
		'cat2',
		'rabbit2',
		'chipmunk',
		'feet',
		'dragon',
		'dragon_face',
		'cactus',
		'christmas_tree',
		'evergreen_tree',
		'deciduous_tree',
		'palm_tree',
		'seedling',
		'herb',
		'shamrock',
		'four_leaf_clover',
		'bamboo',
		'tanabata_tree',
		'leaves',
		'fallen_leaf',
		'maple_leaf',
		'ear_of_rice',
		'hibiscus',
		'sunflower',
		'rose',
		'tulip',
		'blossom',
		'cherry_blossom',
		'bouquet',
		'mushroom',
		'chestnut',
		'jack_o_lantern',
		'shell',
		'spider_web',
		'earth_americas',
		'earth_africa',
		'earth_asia',
		'full_moon',
		'waning_gibbous_moon',
		'last_quarter_moon',
		'waning_crescent_moon',
		'new_moon',
		'waxing_crescent_moon',
		'first_quarter_moon',
		'waxing_gibbous_moon',
		'new_moon_with_face',
		'full_moon_with_face',
		'first_quarter_moon_with_face',
		'last_quarter_moon_with_face',
		'sun_with_face',
		'crescent_moon',
		'star',
		'star2',
		'dizzy',
		'sparkles',
		'comet',
		'sunny',
		'white_sun_small_cloud',
		'partly_sunny',
		'white_sun_cloud',
		'white_sun_rain_cloud',
		'cloud',
		'cloud_rain',
		'thunder_cloud_rain',
		'cloud_lightning',
		'zap',
		'fire',
		'boom',
		'snowflake',
		'cloud_snow',
		'snowman2',
		'snowman',
		'wind_blowing_face',
		'dash',
		'cloud_tornado',
		'fog',
		'umbrella2',
		'umbrella',
		'droplet',
		'sweat_drops',
		'ocean'
	],
	'food': [
		'green_apple',
		'apple',
		'pear',
		'tangerine',
		'lemon',
		'banana',
		'watermelon',
		'grapes',
		'strawberry',
		'melon',
		'cherries',
		'peach',
		'pineapple',
		'tomato',
		'eggplant',
		'hot_pepper',
		'corn',
		'sweet_potato',
		'honey_pot',
		'bread',
		'cheese',
		'poultry_leg',
		'meat_on_bone',
		'fried_shrimp',
		'egg',
		'hamburger',
		'fries',
		'hotdog',
		'pizza',
		'spaghetti',
		'taco',
		'burrito',
		'ramen',
		'stew',
		'fish_cake',
		'sushi',
		'bento',
		'curry',
		'rice_ball',
		'rice',
		'rice_cracker',
		'oden',
		'dango',
		'shaved_ice',
		'ice_cream',
		'icecream',
		'cake',
		'birthday',
		'custard',
		'candy',
		'lollipop',
		'chocolate_bar',
		'popcorn',
		'doughnut',
		'cookie',
		'beer',
		'beers',
		'wine_glass',
		'cocktail',
		'tropical_drink',
		'champagne',
		'sake',
		'tea',
		'coffee',
		'baby_bottle',
		'fork_and_knife',
		'fork_knife_plate'
	],
	'activity': [
		'soccer',
		'basketball',
		'football',
		'baseball',
		'tennis',
		'volleyball',
		'rugby_football',
		'8ball',
		'golf',
		'golfer',
		'ping_pong',
		'badminton',
		'hockey',
		'field_hockey',
		'cricket',
		'ski',
		'skier',
		'snowboarder',
		'ice_skate',
		'bow_and_arrow',
		'fishing_pole_and_fish',
		'rowboat',
		'swimmer',
		'surfer',
		'bath',
		'basketball_player',
		'lifter',
		'bicyclist',
		'mountain_bicyclist',
		'horse_racing',
		'levitate',
		'trophy',
		'running_shirt_with_sash',
		'medal',
		'military_medal',
		'reminder_ribbon',
		'rosette',
		'ticket',
		'tickets',
		'performing_arts',
		'art',
		'circus_tent',
		'microphone',
		'headphones',
		'musical_score',
		'musical_keyboard',
		'saxophone',
		'trumpet',
		'guitar',
		'violin',
		'clapper',
		'video_game',
		'space_invader',
		'dart',
		'game_die',
		'slot_machine',
		'bowling'
	],
	'travel': [
		'red_car',
		'taxi',
		'blue_car',
		'bus',
		'trolleybus',
		'race_car',
		'police_car',
		'ambulance',
		'fire_engine',
		'minibus',
		'truck',
		'articulated_lorry',
		'tractor',
		'motorcycle',
		'bike',
		'rotating_light',
		'oncoming_police_car',
		'oncoming_bus',
		'oncoming_automobile',
		'oncoming_taxi',
		'aerial_tramway',
		'mountain_cableway',
		'suspension_railway',
		'railway_car',
		'train',
		'monorail',
		'bullettrain_side',
		'bullettrain_front',
		'light_rail',
		'mountain_railway',
		'steam_locomotive',
		'train2',
		'metro',
		'tram',
		'station',
		'helicopter',
		'airplane_small',
		'airplane',
		'airplane_departure',
		'airplane_arriving',
		'sailboat',
		'motorboat',
		'speedboat',
		'ferry',
		'cruise_ship',
		'rocket',
		'satellite_orbital',
		'seat',
		'anchor',
		'construction',
		'fuelpump',
		'busstop',
		'vertical_traffic_light',
		'traffic_light',
		'checkered_flag',
		'ship',
		'ferris_wheel',
		'roller_coaster',
		'carousel_horse',
		'construction_site',
		'foggy',
		'tokyo_tower',
		'factory',
		'fountain',
		'rice_scene',
		'mountain',
		'mountain_snow',
		'mount_fuji',
		'volcano',
		'japan',
		'camping',
		'tent',
		'park',
		'motorway',
		'railway_track',
		'sunrise',
		'sunrise_over_mountains',
		'desert',
		'beach',
		'island',
		'city_sunset',
		'city_dusk',
		'cityscape',
		'night_with_stars',
		'bridge_at_night',
		'milky_way',
		'stars',
		'sparkler',
		'fireworks',
		'rainbow',
		'homes',
		'european_castle',
		'japanese_castle',
		'stadium',
		'statue_of_liberty',
		'house',
		'house_with_garden',
		'house_abandoned',
		'office',
		'department_store',
		'post_office',
		'european_post_office',
		'hospital',
		'bank',
		'hotel',
		'convenience_store',
		'school',
		'love_hotel',
		'wedding',
		'classical_building',
		'church',
		'mosque',
		'synagogue',
		'kaaba',
		'shinto_shrine'
	],
	'objects': [
		'watch',
		'iphone',
		'calling',
		'computer',
		'keyboard',
		'desktop',
		'printer',
		'mouse_three_button',
		'trackball',
		'joystick',
		'compression',
		'minidisc',
		'floppy_disk',
		'cd',
		'dvd',
		'vhs',
		'camera',
		'camera_with_flash',
		'video_camera',
		'movie_camera',
		'projector',
		'film_frames',
		'telephone_receiver',
		'telephone',
		'pager',
		'fax',
		'tv',
		'radio',
		'microphone2',
		'level_slider',
		'control_knobs',
		'stopwatch',
		'timer',
		'alarm_clock',
		'clock',
		'hourglass_flowing_sand',
		'hourglass',
		'satellite',
		'battery',
		'electric_plug',
		'bulb',
		'flashlight',
		'candle',
		'wastebasket',
		'oil',
		'money_with_wings',
		'dollar',
		'yen',
		'euro',
		'pound',
		'moneybag',
		'credit_card',
		'gem',
		'scales',
		'wrench',
		'hammer',
		'hammer_pick',
		'tools',
		'pick',
		'nut_and_bolt',
		'gear',
		'chains',
		'gun',
		'bomb',
		'knife',
		'dagger',
		'crossed_swords',
		'shield',
		'smoking',
		'skull_crossbones',
		'coffin',
		'urn',
		'amphora',
		'crystal_ball',
		'prayer_beads',
		'barber',
		'alembic',
		'telescope',
		'microscope',
		'hole',
		'pill',
		'syringe',
		'thermometer',
		'label',
		'bookmark',
		'toilet',
		'shower',
		'bathtub',
		'key',
		'key2',
		'couch',
		'sleeping_accommodation',
		'bed',
		'door',
		'bellhop',
		'frame_photo',
		'map',
		'beach_umbrella',
		'moyai',
		'shopping_bags',
		'balloon',
		'flags',
		'ribbon',
		'gift',
		'confetti_ball',
		'tada',
		'dolls',
		'wind_chime',
		'crossed_flags',
		'izakaya_lantern',
		'envelope',
		'envelope_with_arrow',
		'incoming_envelope',
		'e-mail',
		'love_letter',
		'postbox',
		'mailbox_closed',
		'mailbox',
		'mailbox_with_mail',
		'mailbox_with_no_mail',
		'package',
		'postal_horn',
		'inbox_tray',
		'outbox_tray',
		'scroll',
		'page_with_curl',
		'bookmark_tabs',
		'bar_chart',
		'chart_with_upwards_trend',
		'chart_with_downwards_trend',
		'page_facing_up',
		'date',
		'calendar',
		'calendar_spiral',
		'card_index',
		'card_box',
		'ballot_box',
		'file_cabinet',
		'clipboard',
		'notepad_spiral',
		'file_folder',
		'open_file_folder',
		'dividers',
		'newspaper2',
		'newspaper',
		'notebook',
		'closed_book',
		'green_book',
		'blue_book',
		'orange_book',
		'notebook_with_decorative_cover',
		'ledger',
		'books',
		'book',
		'link',
		'paperclip',
		'paperclips',
		'scissors',
		'triangular_ruler',
		'straight_ruler',
		'pushpin',
		'round_pushpin',
		'triangular_flag_on_post',
		'flag_white',
		'flag_black',
		'closed_lock_with_key',
		'lock',
		'unlock',
		'lock_with_ink_pen',
		'pen_ballpoint',
		'pen_fountain',
		'black_nib',
		'pencil',
		'pencil2',
		'crayon',
		'paintbrush',
		'mag',
		'mag_right'
	],
	'symbols': [
		'100',
		'1234',
		'heart',
		'yellow_heart',
		'green_heart',
		'blue_heart',
		'purple_heart',
		'broken_heart',
		'heart_exclamation',
		'two_hearts',
		'revolving_hearts',
		'heartbeat',
		'heartpulse',
		'sparkling_heart',
		'cupid',
		'gift_heart',
		'heart_decoration',
		'peace',
		'cross',
		'star_and_crescent',
		'om_symbol',
		'wheel_of_dharma',
		'star_of_david',
		'six_pointed_star',
		'menorah',
		'yin_yang',
		'orthodox_cross',
		'place_of_worship',
		'ophiuchus',
		'aries',
		'taurus',
		'gemini',
		'cancer',
		'leo',
		'virgo',
		'libra',
		'scorpius',
		'sagittarius',
		'capricorn',
		'aquarius',
		'pisces',
		'id',
		'atom',
		'u7a7a',
		'u5272',
		'radioactive',
		'biohazard',
		'mobile_phone_off',
		'vibration_mode',
		'u6709',
		'u7121',
		'u7533',
		'u55b6',
		'u6708',
		'eight_pointed_black_star',
		'vs',
		'accept',
		'white_flower',
		'ideograph_advantage',
		'secret',
		'congratulations',
		'u5408',
		'u6e80',
		'u7981',
		'a',
		'b',
		'ab',
		'cl',
		'o2',
		'sos',
		'no_entry',
		'name_badge',
		'no_entry_sign',
		'x',
		'o',
		'anger',
		'hotsprings',
		'no_pedestrians',
		'do_not_litter',
		'no_bicycles',
		'non-potable_water',
		'underage',
		'no_mobile_phones',
		'exclamation',
		'grey_exclamation',
		'question',
		'grey_question',
		'bangbang',
		'interrobang',
		'low_brightness',
		'high_brightness',
		'trident',
		'fleur-de-lis',
		'part_alternation_mark',
		'warning',
		'children_crossing',
		'beginner',
		'recycle',
		'u6307',
		'chart',
		'sparkle',
		'eight_spoked_asterisk',
		'negative_squared_cross_mark',
		'white_check_mark',
		'diamond_shape_with_a_dot_inside',
		'cyclone',
		'loop',
		'globe_with_meridians',
		'm',
		'atm',
		'sa',
		'passport_control',
		'customs',
		'baggage_claim',
		'left_luggage',
		'wheelchair',
		'no_smoking',
		'wc',
		'parking',
		'potable_water',
		'mens',
		'womens',
		'baby_symbol',
		'restroom',
		'put_litter_in_its_place',
		'cinema',
		'signal_strength',
		'koko',
		'ng',
		'ok',
		'up',
		'cool',
		'new',
		'free',
		'zero',
		'one',
		'two',
		'three',
		'four',
		'five',
		'six',
		'seven',
		'eight',
		'nine',
		'ten',
		'arrow_forward',
		'pause_button',
		'play_pause',
		'stop_button',
		'record_button',
		'track_next',
		'track_previous',
		'fast_forward',
		'rewind',
		'twisted_rightwards_arrows',
		'repeat',
		'repeat_one',
		'arrow_backward',
		'arrow_up_small',
		'arrow_down_small',
		'arrow_double_up',
		'arrow_double_down',
		'arrow_right',
		'arrow_left',
		'arrow_up',
		'arrow_down',
		'arrow_upper_right',
		'arrow_lower_right',
		'arrow_lower_left',
		'arrow_upper_left',
		'arrow_up_down',
		'left_right_arrow',
		'arrows_counterclockwise',
		'arrow_right_hook',
		'leftwards_arrow_with_hook',
		'arrow_heading_up',
		'arrow_heading_down',
		'hash',
		'asterisk',
		'information_source',
		'abc',
		'abcd',
		'capital_abcd',
		'symbols',
		'musical_note',
		'notes',
		'wavy_dash',
		'curly_loop',
		'heavy_check_mark',
		'arrows_clockwise',
		'heavy_plus_sign',
		'heavy_minus_sign',
		'heavy_division_sign',
		'heavy_multiplication_x',
		'heavy_dollar_sign',
		'currency_exchange',
		'copyright',
		'registered',
		'tm',
		'end',
		'back',
		'on',
		'top',
		'soon',
		'ballot_box_with_check',
		'radio_button',
		'white_circle',
		'black_circle',
		'red_circle',
		'large_blue_circle',
		'small_orange_diamond',
		'small_blue_diamond',
		'large_orange_diamond',
		'large_blue_diamond',
		'small_red_triangle',
		'black_small_square',
		'white_small_square',
		'black_large_square',
		'white_large_square',
		'small_red_triangle_down',
		'black_medium_square',
		'white_medium_square',
		'black_medium_small_square',
		'white_medium_small_square',
		'black_square_button',
		'white_square_button',
		'speaker',
		'sound',
		'loud_sound',
		'mute',
		'mega',
		'loudspeaker',
		'bell',
		'no_bell',
		'black_joker',
		'mahjong',
		'spades',
		'clubs',
		'hearts',
		'diamonds',
		'flower_playing_cards',
		'thought_balloon',
		'anger_right',
		'speech_balloon',
		'clock1',
		'clock2',
		'clock3',
		'clock4',
		'clock5',
		'clock6',
		'clock7',
		'clock8',
		'clock9',
		'clock10',
		'clock11',
		'clock12',
		'clock130',
		'clock230',
		'clock330',
		'clock430',
		'clock530',
		'clock630',
		'clock730',
		'clock830',
		'clock930',
		'clock1030',
		'clock1130',
		'clock1230',
		'eye_in_speech_bubble'
	],
	'flags': [
		'flag_ac',
		'flag_af',
		'flag_al',
		'flag_dz',
		'flag_ad',
		'flag_ao',
		'flag_ai',
		'flag_ag',
		'flag_ar',
		'flag_am',
		'flag_aw',
		'flag_au',
		'flag_at',
		'flag_az',
		'flag_bs',
		'flag_bh',
		'flag_bd',
		'flag_bb',
		'flag_by',
		'flag_be',
		'flag_bz',
		'flag_bj',
		'flag_bm',
		'flag_bt',
		'flag_bo',
		'flag_ba',
		'flag_bw',
		'flag_br',
		'flag_bn',
		'flag_bg',
		'flag_bf',
		'flag_bi',
		'flag_cv',
		'flag_kh',
		'flag_cm',
		'flag_ca',
		'flag_ky',
		'flag_cf',
		'flag_td',
		'flag_cl',
		'flag_cn',
		'flag_co',
		'flag_km',
		'flag_cg',
		'flag_cd',
		'flag_cr',
		'flag_hr',
		'flag_cu',
		'flag_cy',
		'flag_cz',
		'flag_dk',
		'flag_dj',
		'flag_dm',
		'flag_do',
		'flag_ec',
		'flag_eg',
		'flag_sv',
		'flag_gq',
		'flag_er',
		'flag_ee',
		'flag_et',
		'flag_fk',
		'flag_fo',
		'flag_fj',
		'flag_fi',
		'flag_fr',
		'flag_pf',
		'flag_ga',
		'flag_gm',
		'flag_ge',
		'flag_de',
		'flag_gh',
		'flag_gi',
		'flag_gr',
		'flag_gl',
		'flag_gd',
		'flag_gu',
		'flag_gt',
		'flag_gn',
		'flag_gw',
		'flag_gy',
		'flag_ht',
		'flag_hn',
		'flag_hk',
		'flag_hu',
		'flag_is',
		'flag_in',
		'flag_id',
		'flag_ir',
		'flag_iq',
		'flag_ie',
		'flag_il',
		'flag_it',
		'flag_ci',
		'flag_jm',
		'flag_jp',
		'flag_je',
		'flag_jo',
		'flag_kz',
		'flag_ke',
		'flag_ki',
		'flag_xk',
		'flag_kw',
		'flag_kg',
		'flag_la',
		'flag_lv',
		'flag_lb',
		'flag_ls',
		'flag_lr',
		'flag_ly',
		'flag_li',
		'flag_lt',
		'flag_lu',
		'flag_mo',
		'flag_mk',
		'flag_mg',
		'flag_mw',
		'flag_my',
		'flag_mv',
		'flag_ml',
		'flag_mt',
		'flag_mh',
		'flag_mr',
		'flag_mu',
		'flag_mx',
		'flag_fm',
		'flag_md',
		'flag_mc',
		'flag_mn',
		'flag_me',
		'flag_ms',
		'flag_ma',
		'flag_mz',
		'flag_mm',
		'flag_na',
		'flag_nr',
		'flag_np',
		'flag_nl',
		'flag_nc',
		'flag_nz',
		'flag_ni',
		'flag_ne',
		'flag_ng',
		'flag_nu',
		'flag_kp',
		'flag_no',
		'flag_om',
		'flag_pk',
		'flag_pw',
		'flag_ps',
		'flag_pa',
		'flag_pg',
		'flag_py',
		'flag_pe',
		'flag_ph',
		'flag_pl',
		'flag_pt',
		'flag_pr',
		'flag_qa',
		'flag_ro',
		'flag_ru',
		'flag_rw',
		'flag_sh',
		'flag_kn',
		'flag_lc',
		'flag_vc',
		'flag_ws',
		'flag_sm',
		'flag_st',
		'flag_sa',
		'flag_sn',
		'flag_rs',
		'flag_sc',
		'flag_sl',
		'flag_sg',
		'flag_sk',
		'flag_si',
		'flag_sb',
		'flag_so',
		'flag_za',
		'flag_kr',
		'flag_es',
		'flag_lk',
		'flag_sd',
		'flag_sr',
		'flag_sz',
		'flag_se',
		'flag_ch',
		'flag_sy',
		'flag_tw',
		'flag_tj',
		'flag_tz',
		'flag_th',
		'flag_tl',
		'flag_tg',
		'flag_to',
		'flag_tt',
		'flag_tn',
		'flag_tr',
		'flag_tm',
		'flag_tv',
		'flag_ug',
		'flag_ua',
		'flag_ae',
		'flag_gb',
		'flag_us',
		'flag_vi',
		'flag_uy',
		'flag_uz',
		'flag_vu',
		'flag_va',
		'flag_ve',
		'flag_vn',
		'flag_wf',
		'flag_eh',
		'flag_ye',
		'flag_zm',
		'flag_zw',
		'flag_re',
		'flag_ax',
		'flag_ta',
		'flag_io',
		'flag_bq',
		'flag_cx',
		'flag_cc',
		'flag_gg',
		'flag_im',
		'flag_yt',
		'flag_nf',
		'flag_pn',
		'flag_bl',
		'flag_pm',
		'flag_gs',
		'flag_tk',
		'flag_bv',
		'flag_hm',
		'flag_sj',
		'flag_um',
		'flag_ic',
		'flag_ea',
		'flag_cp',
		'flag_dg',
		'flag_as',
		'flag_aq',
		'flag_vg',
		'flag_ck',
		'flag_cw',
		'flag_eu',
		'flag_gf',
		'flag_tf',
		'flag_gp',
		'flag_mq',
		'flag_mp',
		'flag_sx',
		'flag_ss',
		'flag_tc',
		'flag_mf'
	],
	'modifier': [
		'tone1',
		'tone2',
		'tone3',
		'tone4',
		'tone5'
	]*/
};
