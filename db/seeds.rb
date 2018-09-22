# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Language.create(name: "Englisch")
Language.create(name: "Deutsch")
Language.create(name: "Farsi")

Ability.create(name:        "Medizin",
               description: "kann medizinische Hilfestellung bieten")
Ability.create(name:        "Übersetzung",
               description: "kann Dokumente in den angegebenen Sprachen übersetzen")

OngoingEventCategory.create([
  { name_de: "Lernhilfe", name_en: "Educational Support", ordinal: 100 },
  { name_de: "Patenschaft", name_en: "Buddy/Mentoring", ordinal: 200 },
  { name_de: "Unterstützung im Alltag", name_en: "Support in everyday life", ordinal: 300 },
  { name_de: "Unterricht", name_en: "Teaching", ordinal: 400 },
  { name_de: "Sport und Freizeit", name_en: "Sport and Leisure", ordinal: 500 },
  { name_de: "Übersetzungstätigkeit", name_en: "Translating", ordinal: 600 },
])
