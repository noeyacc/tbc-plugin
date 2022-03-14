if GetLocale() ~= "ruRU" then return end

if not DBM_GUI_L then DBM_GUI_L = {} end
local L = DBM_GUI_L

L.MainFrame = "Deadly Boss Mods"

-- Missing phrases. Start ..
L.Core_GUI 					= "Ядро и графический интерфейс"
L.Button_MoveBars			= "Переместить фреймы / полосы"
L.Area_BasicSetup			= "Советы по начальной настройке DBM"
L.Area_ModulesForYou		= "Какие модули DBM подходят именно Вам?"
L.Area_ProfilesSetup		= "Руководство по использованию профилей DBM"
L.Area_ImportExportProfile	= "Импорт / Экспорт профилей"
L.ImportExportInfo			= "Импорт перезапишет Ваш текущий профиль. Делайте это на свой страх и риск."
L.ButtonImportProfile		= "Импорт профиля"
L.ButtonExportProfile		= "Экспорт профиля"
L.ResizeOptions			 	= "Параметры изменения размера"
L.ResizeInfo				= "Вы можете изменить размер графического интерфейса, щелкнув в правом нижнем углу и перетащить."
L.Button_ResetWindowSize	= "Сбросить размер окна"
L.Editbox_WindowWidth		= "Ширина окна"
L.Editbox_WindowHeight		= "Высота окна"
L.TabCategory_Alerts	 	= "Оповещения"
L.Area_SpecAnnounceConfig	= "Специальное объявление: визуальные эффекты и звуковое руководство"
L.Area_SpecAnnounceNotes	= "Руководство по специальным объявлениям"
L.Area_VoicePackInfo		= "Информация о голосовых пакетах DBM"
L.ShortTextSpellname		= "Используйте более короткий текст названия (если доступно)"
L.Area_BugAlerts			= "Параметры предупреждений об ошибках"
L.BadTimerAlert				= "Показывать сообщение в чате, когда DBM обнаруживает неверный таймер с ошибкой не менее 1 секунды"
L.BadIDAlert				= "Показывать сообщение в чате, когда DBM обнаруживает, что используется недопустимый идентификатор заклинания или журнала"
L.ShowReminders				= "Показывать напоминания об отсутствующих сабмодах, отключенных сабмодах, исправлениях сабмодов, устаревших сабмодах и включенном беззвучном режиме.<br/>ПРИМЕЧАНИЕ: сабмод - дополнение к основному моду. Например: DBM-Legion является дополнением к DBM Core."
L.SpecWarn_Flash			= "Экран вспышки"
L.SpecWarn_Vibrate			= "Контроллер вибрации"
L.SpecialWarnSoundOption	= "Установить звук по умолчанию"
L.SpecialWarnHeader1		= "Тип 1: установите параметры для обычных приоритетных объявлений, влияющих на Вас или Ваши действия."
L.SpecialWarnHeader2		= "Тип 2: установите параметры для объявлений с обычным приоритетом, влияющих на всех."
L.SpecialWarnHeader3		= "Тип 3: установите параметры для объявлений с ВЫСОКИМ приоритетом."
L.SpecialWarnHeader4		= "Тип 4: Установите параметры для ВЫСОКО приоритетных специальных объявлений о побегах."
L.SpecialWarnHeader5		= "Тип 5: установите параметры для объявлений с примечаниями, содержащими Ваше имя игрока."
L.Panel_Appearance	 		= "Внешний вид полос"
L.NoBarFade					= "Используйте начальные/конечные цвета как маленькие/большие цвета вместо постепенного изменения цвета"
L.BarSaturation				= "Насыщенность полос для маленьких таймеров (когда огромные полосы отключены): %0.2f"
L.Panel_ColorByType	 		= "Цвет по типу"
L.Panel_Behavior	 		= "Поведение полос"
L.AreaTitle_Behavior		= "Параметры поведения полос"
L.TabCategory_Filters	 	= "Глобальные отключения и фильтры"
L.Area_DBMFiltersSetup		= "Руководство по фильтрам DBM"
L.Area_SyncMessages			= "Параметры синхронизации аддонов"
L.EnableWBSharing 			= "Поделитесь, когда Вы пулите или побеждаете мирового босса со своей гильдией и друзьями из Battle.net, которые находятся в одном игровом мире."
L.SpamBlockNoSpecWarnFlash			= "Не показывать специальное объявление экранной вспышки"
L.SpamBlockNoSpecWarnVibrate		= "Не вибрировать контроллер на специальном объявлении"
L.SpamBlockNoSpecWarnSound			= "Не воспроизводить специальные звуки объявлений (по-прежнему разрешены голосовые пакеты, если они включены на панели голосовых предупреждений)"
L.SpamBlockNoTrivialSpecWarnSound	= "Не воспроизводите специальные звуки объявления и не показывайте вспышку экрана для контента, который является слишком простым для Вашего уровня (вместо этого воспроизводит выбранный пользователем обычный звук объявления)"
L.Tab_Privacy 				= "Контроль конфиденциальности"
L.TabCategory_Frames		= "Рамки и интеграции"
L.Area_NamelateInfo			= "Информация об аурах нэймплейтов DBM"
L.Area_General				= "Общие"
L.Area_Style				= "Стиль"
L.Panel_InfoFrame			= "Инфофрейм"
L.Panel_Range				= "Дистанция"
L.Panel_Nameplates			= "Нэймплейты"
L.UseNameplateHandoff		= "Передавать запросы ауры нэймплейтов поддерживаемым аддонам (KuiNameplates, Threat Plates, Plater) вместо внутренней обработки. Это рекомендуемый вариант, так как он позволяет выполнять более продвинутые функции и настройку с помощью надстройки нэймплейтов."
L.NPAuraSize				= "Размер пикселя ауры (в квадрате): %d"
L.MissingVoicePack			= "Отсутствующий голосовой пакет (%s)"
L.ExtendIcons				= "Расширьте API значков целей рейда, чтобы использовать до 16 значков (вместо 8).<br/>ВАЖНО: эти значки НЕ будут видны тем, у кого не установлен пользовательский файл текстуры «UI-RaidTargetingIcons.blp», который поддерживает 16 значков.<br />Необходимо перезагрузить пользовательский интерфейс после включения или отключения этой функции."
L.RecordOnlyBosses			= "Записывать только боссов. Исключить весь трэш.<br/>Используйте '/dbm pull' перед боссами, чтобы до пулла выпить поты и начать схватку!"
L.EventEngagePT				= "Установить звук для запуска таймера пулла"
L.Area_ColorBytype			= "Цветные полосы по типу (руководство)"
L.Area_SpamFilter_SpecFeatures		= "Переключить определенные функции специальных объявлений"
L.Area_SpamFilter_SpecRoleFilters	= "Специальные фильтры типов объявлений (контролируют, сколько ручных операций делает DBM)"
L.SpamSpecRoleDispel				= "Фильтр 'рассеивающих' оповещений"
L.SpamSpecRoleInterrupt				= "Фильтр 'прерываемых' оповещений"
L.SpamSpecRoleDefensive				= "Фильтр 'защитных' оповещений"
L.SpamSpecRoleTaunt					= "Фильтр 'провокационных' оповещений (для танков 'таунт')"
L.SpamSpecRoleSoak					= "Фильтр 'поглощающих' оповещений"
L.SpamSpecRoleStack					= "Фильтр 'high stack' оповещений"
L.SpamSpecRoleSwitch				= "Фильтр оповещений о 'смене цели' &amp; 'аддов'"
L.SpamSpecRoleGTFO					= "Фильтр 'GTFO' оповещений"
-- Missing phrases. End ..

L.TranslationByPrefix		= "Перевод на русский язык - "
L.TranslationBy 			= "Swix, TOM_RUS"
L.Website					= "Посетите наши новые форумы обсуждения и поддержки на |cFF73C2FBwww.deadlybossmods.com|r"
L.WebsiteButton				= "Форумы"

L.OTabBosses				= "Боссы"
L.OTabOptions				= "Настройки"

L.TabCategory_Options	 	= "Общие параметры"
L.TabCategory_OTHER 		= "Другие боссы"

L.BossModLoaded 			= "%s - статистика"
L.BossModLoad_now 			= [[Модуль для этих боссов не загружен.
Он будет загружен сразу после входа в подземелье.
Также Вы можете нажать кнопку, чтобы загрузить модуль вручную.]]

L.PosX						= "Позиция X"
L.PosY						= "Позиция Y"

L.MoveMe 					= "Передвинь меня"
L.Button_OK 				= "OK"
L.Button_Cancel 			= "Отмена"
L.Button_LoadMod			= "Загрузить модуль"
L.Mod_Enabled				= "Включить модуль"
L.Mod_Reset					= "Сброс настроек"
L.Reset 					= "Сброс"

L.Enable					= "Вкл."
L.Disable					= "Откл."

L.NoSound					= "Без звука"

L.IconsInUse				= "Используемые метки"

-- Tab: Boss Statistics
L.BossStatistics			= "Статистика босса"
L.Statistic_Kills			= "Убийства:"
L.Statistic_Wipes			= "Поражения:"
L.Statistic_Incompletes		= "Не завершено:"
L.Statistic_BestKill		= "Лучший бой:"
L.Statistic_BestRank		= "Лучший ранг:"--Maybe not get used, not sure yet, localize anyways

-- Tab: General Core Options
L.General 					= "Общие параметры DBM"
L.EnableMiniMapIcon			= "Отображать кнопку на миникарте"
L.UseSoundChannel			= "Выбор аудио канала для предупреждений DBM"
L.UseMasterChannel			= "Основной аудио канал"
L.UseDialogChannel			= "Аудио канал диалогов"
L.UseSFXChannel				= "Аудио канал эффектов"
L.Latency_Text				= "Макс. задержка для синхронизации: %d"

L.ModelOptions				= "Настройки 3D моделей на странице боссов"
L.EnableModels				= "Показывать 3D модели боссов"
L.ModelSoundOptions			= "Выбор голосового приветствия"
L.ModelSoundShort			= "Короткое"
L.ModelSoundLong			= "Длинное"

L.Button_RangeFrame			= "Окно проверки дистанции"
L.Button_InfoFrame			= "Окно информации"
L.Button_TestBars			= "Проверка индикаторов"
L.Button_ResetInfoRange		= "Сбросить информ./дист. окна"

-- Tab: Raidwarning
L.Tab_RaidWarning 			= "Предупреждения для рейда"
L.RaidWarning_Header		= "Параметры рейд-предупреждений"
L.RaidWarnColors 			= "Цвета предупреждений для рейда"
L.RaidWarnColor_1 			= "Цвет 1"
L.RaidWarnColor_2 			= "Цвет 2"
L.RaidWarnColor_3		 	= "Цвет 3"
L.RaidWarnColor_4 			= "Цвет 4"
L.InfoRaidWarning			= [[Вы можете указать расположение и цвет предупреждений для рейда.
Используется для сообщений вроде "Игрок X под воздействием Y"]]
L.ColorResetted 			= "Цветовые параметры для этого поля восстановлены."
L.ShowWarningsInChat 		= "Показывать предупреждения в окне чата"
L.WarningIconLeft 			= "Отображать значок с левой стороны"
L.WarningIconRight 			= "Отображать значок с правой стороны"
L.WarningIconChat 			= "Отображать значки в окне чата"
L.WarningAlphabetical		= "Сортировать имена по алфавиту"
L.Warn_Duration				= "Длительность предупреждения: %0.1f сек"
L.None						= "Нет"
L.Random					= "Случайно"
L.Outline					= "Контур"
L.ThickOutline				= "Толстый контур"
L.MonochromeOutline			= "Монохромный контур"
L.MonochromeThickOutline	= "Монохромный толстый контур"
L.RaidWarnSound				= "Звук рейд-предупреждения"

-- Tab: Generalwarnings
L.Tab_GeneralMessages 		= "Общие сообщения"
L.CoreMessages				= "Параметры общих сообщений"
L.ShowPizzaMessage 			= "Показывать сообщения транслируемых таймеров в окне чата"
L.ShowAllVersions	 		= "Показывать версии босс мода для всех членов группы в окне чата"
L.CombatMessages			= "Параметры сообщений в бою"
L.ShowEngageMessage 		= "Показывать сообщения о вступлении в бой в окне чата"
L.ShowDefeatMessage 		= "Показывать сообщения об убийстве босса в окне чата"
L.ShowGuildMessages 		= "Показывать сообщения о вступлении в бой/убийстве/вайпе рейда гильдии в окне чата"
L.ShowGuildMessagesPlus		= "Также показывать сообщения о вступлении в бой/убийстве/вайпе для группы гильдии в M+ (требуется опция рейда)"
L.Area_WhisperMessages		= "Параметры приватных сообщений"
L.AutoRespond 				= "Включить автоответ в бою"
L.WhisperStats 				= "Добавлять статистику убийств/вайпов в автоответ"
L.DisableStatusWhisper 		= "Отключить ответы на запрос статуса боя шепотом для всей группы (требуется лидер группы).<br/>Применяется только для обычных/гер./эпох. рейдов и испытаний/эпох. подземелий"
L.DisableGuildStatus 		= "Отключить отправку гильдии сообщений о прогрессе для всей группы (требуется лидер группы)"

-- Tab: Barsetup
L.TabCategory_Timers		= "Настройки индикатора"
L.BarTexture 				= "Текстура индикатора"
L.BarStyle					= "Стиль индикатора"
L.BarDBM					= "DBM"
L.BarSimple					= "Простой (без анимации)"
L.BarStartColor				= "Цвет в начале"
L.BarEndColor 				= "Цвет в конце"
L.Bar_Height				= "Высота индикатора: %d"
L.Slider_BarOffSetX 		= "Сдвиг X: %d"
L.Slider_BarOffSetY 		= "Сдвиг Y: %d"
L.Slider_BarWidth 			= "Ширина: %d"
L.Slider_BarScale 			= "Масштаб: %0.2f"
--Types
L.BarStartColorAdd			= "Начальный цвет (Помощник)"
L.BarEndColorAdd			= "Конечный цвет (Помощник)"
L.BarStartColorAOE			= "Начальный цвет (Урон по области)"
L.BarEndColorAOE			= "Конечный цвет (Урон по области)"
L.BarStartColorDebuff		= "Начальный цвет (Цель)"
L.BarEndColorDebuff			= "Конечный цвет (Цель)"
L.BarStartColorInterrupt	= "Начальный цвет (Прерывание)"
L.BarEndColorInterrupt		= "Конечный цвет (Прерывание)"
L.BarStartColorRole			= "Начальный цвет (Роль)"
L.BarEndColorRole			= "Конечный цвет (Роль)"
L.BarStartColorPhase		= "Начальный цвет (Фаза)"
L.BarEndColorPhase			= "Конечный цвет (Фаза)"
L.BarStartColorUI			= "Начальный цвет (Польз.)"
L.BarEndColorUI				= "Конечный цвет (Польз.)"
--Type 7 options
L.Bar7Header				= "Параметры пользовательского индикатора"
L.Bar7ForceLarge			= "Всегда использовать большой индикатор"
L.Bar7CustomInline			= "Использовать пользовательскую '!' встроенную иконку"

-- Tab: Timers
L.AreaTitle_BarColors		= "Цвета индикатора по типу таймера"
L.AreaTitle_BarSetup		= "Параметры основного индикатора"
L.AreaTitle_BarSetupSmall 	= "Параметры уменьшенного индикатора"
L.AreaTitle_BarSetupHuge	= "Параметры увеличенного индикатора"
L.EnableHugeBar 			= "Включить увеличенный индикатор (Полоса 2)"
L.BarIconLeft 				= "Значок слева"
L.BarIconRight 				= "Значок справа"
L.ExpandUpwards				= "Выровнять по верху"
L.FillUpBars				= "Наполняющая заливка"
L.ClickThrough				= "Отключить события мыши (щелчок сквозь)"
L.Bar_Decimal				= "Отображать десятые когда время меньше: %d"
L.Bar_Alpha					= "Прозрачность: %0.1f"
L.Bar_EnlargeTime			= "Увеличивать, когда время меньше: %d"
L.BarSpark					= "Искрение индикатора"
L.BarFlash					= "Мигание, когда индикатор скоро исчезнет"
L.BarSort					= "Сортировать по оставшемуся времени"
L.BarColorByType			= "Цвет по типу"
L.BarInlineIcons			= "Показывать встроенные иконки"
L.ShortTimerText			= "Использовать короткий текст таймера (когда доступен)"
L.KeepBar					= "Оставить таймер активным до применения способности"
L.KeepBar2					= "(когда поддерживается модулем)"
L.FadeBar					= "Таймеры исчезновения для способностей вне диапазона"

-- Tab: Spec Warn Frame
L.Panel_SpecWarnFrame		= "Специальные предупреждения для рейда"
L.Area_SpecWarn				= "Настройка специальных предупреждений"
L.SpecWarn_ClassColor		= "Использовать цвета классов для спецпредупреждений"
L.ShowSWarningsInChat 		= "Показывать спецпредупреждения в окне чата"
L.SWarnNameInNote			= "Использовать SW5 настройки, если пользовательская заметка содержит Ваше имя"
L.SpecialWarningIcon		= "Показывать иконки на специальных предупреждениях"
L.SpecWarn_FlashFrameRepeat	= "Повторять %d раз (если включено)"
L.SpecWarn_FlashRepeat		= "Повторять мигание"
L.SpecWarn_FlashColor		= "Цвет мигания"
L.SpecWarn_FlashDur			= "Длительности мигания: %0.1f"
L.SpecWarn_FlashAlpha		= "Прозрачность мигания: %0.1f"
L.SpecWarn_DemoButton		= "Показать пример"
L.SpecWarn_ResetMe			= "Восстановить умолчания"

-- Tab: Spoken Alerts Frame
L.Panel_SpokenAlerts		= "Голосовые предупреждения"
L.Area_VoiceSelection		= "Выбор голоса"
L.CountdownVoice			= "Основной голос для звуков отсчета"
L.CountdownVoice2			= "Вторичный голос для звуков отсчета"
L.CountdownVoice3			= "Третичный голос для звуков отсчета"
L.VoicePackChoice			= "Голосовой пакет для предупреждений"
L.Area_CountdownOptions		= "Настройки обратного отсчета"
L.Area_VoicePackOptions		= "Настройки голосового пакета (голосовые пакеты третих лиц)"
L.SpecWarn_NoSoundsWVoice	= "Не проигрывать звуки спецпредупреждений для предупреждений, которые имеют голосовую настройку"
L.SWFNever					= "Никогда"
L.SWFDefaultOnly			= "Когда спецпредупреждения используют звуки по умолчанию (позволяет проигрывать пользовательские звуки)"
L.SWFAll					= "Когда спецпредупреждения используют любые звуки"
L.SpecWarn_AlwaysVoice		= "Всегда воспроизводить все голосовые предупреждения (даже если спецпредупреждения отключены).<br/>Полезно для рейд лидера, иначе не рекомендуется."
--TODO, maybe add URLS right to GUI panel on where to acquire 3rd party voice packs?
L.Area_GetVEM				= "Получить голосовой пакет VEM"
L.VEMDownload				= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/dbm-voicepack-vem|r"
L.Area_BrowseOtherVP		= "Посмотреть другие голосовые пакеты на Curse"
L.BrowseOtherVPs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+voice|r"
L.Area_BrowseOtherCT		= "Посмотреть пакеты обратного отсчета на Curse"
L.BrowseOtherCTs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+count+pack|r"

-- Tab: Event Sounds
L.Panel_EventSounds			= "Звуки событий"
L.Area_SoundSelection		= "Выбор звука (прокрутите меню выбора колесом мыши)"
L.EventVictorySound			= "Установить звук при победе в бою"
L.EventWipeSound			= "Установить звук при поражении в бою"
L.EventEngageSound			= "Установить звук при вступлении в бой"
L.EventDungeonMusic			= "Установить музыку в подземельях/рейдах"
L.EventEngageMusic			= "Установить музыку во время боя"
L.Area_EventSoundsExtras	= "Настройки звуков событий"
L.EventMusicCombined		= "Разрешить все варианты выбора музыки для подземелий и боя (изменение этой настройки требует перезагрузки интерфейса, чтобы увидеть изменения)"
L.Area_EventSoundsFilters	= "Условия фильтра звуков событий"
L.EventFilterDungMythicMusic= "Не проигрывать музыку подземелья на эпохальной/эпохальной+ сложности"
L.EventFilterMythicMusic	= "Не проигрывать музыку боя на эпохальной/эпохальной+ сложности"

-- Tab: Global Filter
L.Panel_SpamFilter			= "Глобальные отключения и фильтры"
L.Area_SpamFilter_Anounces	= "Глобальное отключение и параметры фильтрации"
L.SpamBlockNoShowAnnounce	= "Не показывать текст или проигрывать звук для ЛЮБЫХ общих объявлений"
L.SpamBlockNoShowTgtAnnounce= "Не показывать текст или проигрывать звук для общих объявлений ЦЕЛИ (фильтр выше переопределяет этот)"
L.SpamBlockNoSpecWarnText	= "Не показывать текст спецпредупреждений, но разрешить голосовые пакеты (фильтр выше переопределяет этот)"

L.Area_SpamFilter_Timers	= "Глобальное отключение таймера и параметры фильтра"
L.SpamBlockNoShowTimers		= "Не показывать таймеры (отсчет времени)"
L.SpamBlockNoShowUTimers	= "Не показывать таймеры, отправленные пользователями (пользов./пулл/отдых)"
L.SpamBlockNoCountdowns		= "Не воспроизводить звуки обратного отсчета"

L.Area_SpamFilter_Misc		= "Разное глобальное отключение и параметры фильтра"
L.SpamBlockNoSetIcon		= "Не устанавливать метки на цели"
L.SpamBlockNoRangeFrame		= "Не показывать окно проверки дистанции"
L.SpamBlockNoInfoFrame		= "Не показывать информационное окно"
L.SpamBlockNoHudMap			= "Не показывать HudMap"
L.SpamBlockNoNameplate		= "Не показывать Nameplate Auras (отключает полностью)"
L.SpamBlockNoNameplateLines	= "Не показывать линии Nameplate Aura (иконки аур будут отображаться)"
L.SpamBlockNoYells			= "Не отправлять крики в чат"
L.SpamBlockNoNoteSync		= "Не принимать заметки"

L.Area_Restore				= "Параметры DBM для возврата настроек (восстанавливать ли предыдущее пользов. состояние по окончание работы модулей)"
L.SpamBlockNoIconRestore	= "Не сохранять состояние меток и восстанавливать их после боя"
L.SpamBlockNoRangeRestore	= "Не восстанавливать окно проверки дистанции в предыдущее состояние при скрытии модулями"

-- Tab: Spam Filter
L.Area_SpamFilter			= "Параметры спам-фильтра"
L.DontShowFarWarnings		= "Не отображать предупреждения/таймеры для событий, которые далеко"
L.StripServerName			= "Удалять имя сервера в предупреждениях и таймерах"

L.Area_SpecFilter			= "Параметры фильтра по роли"
L.FilterTankSpec			= "Фильтровать предупреждения для роли танка, когда не в специализации танка. (примечание: отключение этого параметра не рекомендуется для большинства пользователей, поскольку теперь все предупреждения «таунта» включены по умолчанию)"
L.FilterInterruptsHeader	= "Фильтровать предупреждения для прерываемых спеллов на основе предпочтений поведения."
L.FilterInterrupts			= "Если кастер не является Вашей текущей целью/фокусом (всегда)"
L.FilterInterrupts2			= "Если кастер не является Вашей текущей целью/фокусом (всегда) или сбитие на кд (только босс)"
L.FilterInterrupts3			= "Если кастер не является Вашей текущей целью/фокусом (всегда) или сбитие на кд (босс и трэш)"
L.FilterInterrupts4			= "Всегда фильтровать объявления о прерываниях (Вы не хотите их видеть)"
L.FilterInterruptNoteName	= "Фильтровать предупреждения для прерываемых спеллов (со счетчиком), если предупреждение не содержит Ваше имя в пользов. заметке"
L.FilterDispels				= "Фильтровать предупреждения для рассеиваемых спеллов, если Ваш диспел в кулдауне"
L.FilterTrashWarnings		= "Фильтровать предупреждения для трэша в обычных и героических подземельях"

L.Area_PullTimer			= "Параметры фильтра таймеров пулла/боя/пользов."
L.DontShowPTNoID			= "Блокировать таймер пулла, отправленный из другой зоны"
L.DontShowPT				= "Не отображать индикатор таймера пулла"
L.DontShowPTText			= "Не отображать текст объявления для таймера пулла"
L.DontShowPTCountdownText	= "Не отображать текст отсчета таймера пулла"
L.DontPlayPTCountdown		= "Не воспроизводить звук отсчета таймера пулла/боя/пользов."
L.PT_Threshold				= "Не отображать текст отсчета таймера пулла/боя/пользов. больше: %d"

L.Panel_HideBlizzard		= "Скрыть Blizzard"
L.Area_HideBlizzard			= "Настройки скрытия Blizzard"
L.HideBossEmoteFrame		= "Скрывать окно эмоций рейдового босса во время боя с боссом"
L.HideWatchFrame			= "Скрывать окно отслеживания заданий во время боя с боссом"
L.HideGarrisonUpdates		= "Скрывать уведомления из гарнизона во время боя с боссом"
L.HideGuildChallengeUpdates	= "Скрывать уведомления о гильдейских испытаниях во время боя с боссами"
L.HideQuestTooltips			= "Скрывать цели заданий в подсказках во время боя с боссами"
L.HideTooltips				= "Скрывать подсказки во время боя с боссом"
L.DisableSFX				= "Отключить канал звуковых эффектов во время боя с боссами"
L.DisableCinematics			= "Отключить внутриигровые ролики"
L.OnlyFight					= "Только во время боя, после того, как ролик был показан один раз"
L.AfterFirst				= "После одного просмотра"
L.CombatOnly				= "Отключить в бою (любом)"
L.RaidCombat				= "Отключить в бою (только боссы)"

L.Panel_ExtraFeatures		= "Дополнительные возможности"
--
L.Area_ChatAlerts			= "Параметры оповещений в чате"
L.RoleSpecAlert				= "Показывать предупреждение, когда Ваша специализация добычи не совпадает с текущей специализацией при присоединении к рейду"
L.CheckGear					= "Показывать предупреждение, когда уровень надетых предметов намного ниже, чем максимальный (40+)"
L.WorldBossAlert			= "Показывать предупреждение, когда в Вашем игровом мире ваши друзья или согильдийцы возможно вступают в бой с боссами вне подземелья (неточно, если отправитель в межсерверной зоне)"
--
L.Area_SoundAlerts			= "Параметры звуковых оповещений"
L.LFDEnhance				= "Проигрывать звук проверки готовности для проверки ролей и приглашений на БГ/ЛФГ через основной аудио канал"
L.WorldBossNearAlert		= "Проигрывать звук проверки готовности, когда неподалеку пулят нужных Вам боссов вне подземелья (переопределяет настройку для конкретного босса)"
L.RLReadyCheckSound			= "Проигрывать звук проверки готовности при проверке готовности через основной аудио канал или канал диалогов"
L.AFKHealthWarning			= "Звуковое оповещение, если Вы теряете здоровье во время АФК"
L.AutoReplySound			= "Звуковое оповещение при получении автоответа шепотом от DBM"
--
L.TimerGeneral 				= "Параметры таймера"
L.SKT_Enabled				= "Всегда отображать таймер рекордной победы (переопределяет настройку для конкретного босса)"
L.ShowRespawn				= "Отсчет времени до появления босса после вайпа"
L.ShowQueuePop				= "Отсчет оставшегося времени до принятия очереди (поиск группы, БГ и т.д.)"
--
L.Area_AutoLogging			= "Параметры автоматической записи"
L.AutologBosses				= "Автоматически записывать бои с боссами, используя журнал боя Blizzard (требуется использовать '/dbm pull' перед боссами для совместимости с <a href=\"http://www.warcraftlogs.com\">|cff3588ffwarcraftlogs.com|r</a>)"
L.AdvancedAutologBosses		= "Автоматически записывать бои с боссами, используя Transcriptor"
L.LogOnlyNonTrivial			= "Записывать только специфические бои с рейдовыми боссами (обычные или более сложные актуальные рейды) и Миф+ подземелья"
--
L.Area_3rdParty				= "Параметры аддонов третих лиц"
--L.oRA3AnnounceConsumables	= "Announce oRA3 consumables check on combat start"
L.Area_Invite				= "Параметры приглашений"
L.AutoAcceptFriendInvite	= "Автоматически принимать приглашения в группу от друзей"
L.AutoAcceptGuildInvite		= "Автоматически принимать приглашения в группу от согильдийцев"
L.Area_Advanced				= "Дополнительные настройки"
L.FakeBW					= "Притворяться BigWigs вместо DBM при приверке версий (полезно для гильдий, которые заставляют использовать BigWigs)"
L.AITimer					= "Автоматически генерируйте таймеры для невиданных ранее боев, используя встроенный таймер AI в DBM (полезно для первого вызова тестового босса, такого как бета-версия или PTR). Примечание: это не будет работать должным образом для нескольких аддов с одной и той же способностью."

L.Panel_Profile				= "Профили"
L.Area_CreateProfile		= "Создание профиля настроек DBM Core"
L.EnterProfileName			= "Введите имя профиля"
L.CreateProfile				= "Создать новый профиль со стандартными настройками"
L.Area_ApplyProfile			= "Выбор активного профиля"
L.SelectProfileToApply		= "Выберите профиль для применения"
L.Area_CopyProfile			= "Копирование профиля настроек DBM Core"
L.SelectProfileToCopy		= "Выберите профиль для копирования"
L.Area_DeleteProfile		= "Удаление профиля настроек DBM Core"
L.SelectProfileToDelete		= "Выберите профиль для удаления"
L.Area_DualProfile			= "Настройки профиля для босс-модулей"
L.DualProfile				= "Включить поддержку разных настроек босс-модулей для специализаций.<br/>Управление профилями босс-модулей производится с экрана статистики загруженного модуля."

L.Area_ModProfile			= "Копирование настроек модуля с другого персонажа/спека или удаление настроек модуля"
L.ModAllReset				= "Сбросить все настройки модуля"
L.ModAllStatReset			= "Сбросить всю статистику модуля"
L.SelectModProfileCopy		= "Скопировать все настройки из"
L.SelectModProfileCopySound	= "Скопировать настройки звука из"
L.SelectModProfileCopyNote	= "Скопировать заметки из"
L.SelectModProfileDelete	= "Удалить настройки модуля для"

-- Misc
L.FontType					= "Выбор шрифта"
L.FontStyle					= "Флаги шрифта"
L.FontColor					= "Цвет шрифта"
L.FontShadow				= "Тень"
L.FontSize					= "Размер шрифта: %d"

L.FontHeight	= 16