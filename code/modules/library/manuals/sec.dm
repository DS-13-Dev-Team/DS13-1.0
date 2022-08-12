/obj/item/book/manual/earthgov_law
	name = "Earth Government Law"
	desc = "A brief overview of EarthGov Law."
	icon_state = "bookSolGovLaw"
	author = "The Earth Government Colonial Alliance"
	title = "Earth Government Law"

/obj/item/book/manual/earthgov_law/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[CONFIG_GET(string/wikiurl)]EarthGov_Law" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/earthgov_sop
	name = "Standard Operating Procedure"
	desc = "SOP aboard the USG Ishimura."
	icon_state = "booksolregs"
	author = "The Earth Government Colonial Alliance"
	title = "Standard Operating Procedure"

/obj/item/book/manual/earthgov_sop/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[CONFIG_GET(string/wikiurl)]Standard_Operating_Procedure" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}
