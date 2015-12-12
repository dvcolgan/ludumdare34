QWERTY = [
    ["Q", 'W', 'E', 'R', 'U', 'I', 'O', 'P']
    ['A', 'S', 'D', 'F', 'J', 'K', 'L', ';']
    ['Z', 'X', 'C', 'V', 'M', ',', '.', '/']
]
DVORAK = [
    ["'", ',', '.', 'P', 'G', 'C', 'R', 'L']
    ['A', 'O', 'E', 'U', 'H', 'T', 'N', 'S']
    [';', 'Q', 'J', 'K', 'M', 'W', 'V', 'Z']
]

KEYMAP = DVORAK

class PlayerShip extends Phaser.Sprite
    constructor: (@game, x, y) ->
        super(@game, x, y, 'player-ship')
        @game.add.existing(@)


class Planet
    constructor: (@game, x, y, letter) ->
        @sprite = @game.add.sprite(x, y, 'planets')
        @sprite.anchor.setTo(0.5, 0.5)
        @sprite.animations.add('planets', [0,1,2,3], 0)
        @sprite.animations.play('planets')
        @sprite.animations.stop('planets')
        @sprite.animations.frame = @game.rnd.integerInRange(0, 3)
        @sprite.scale.set(@game.rnd.realInRange(0.8, 1.5))

        @text = @game.add.text(x, y, letter)
        @text.anchor.setTo(0.5, 0.5)

        @hide()

    hide: ->
        @hidden = true
        @sprite.visible = false
        @text.setStyle
            fill: 'grey'
    show: ->
        @hidden = false
        @sprite.visible = true
        @text.setStyle
            fill: 'black'

    toggle: ->
        if @hidden then @show() else @hide()


class PreloadState
    preload: ->
        @game.load.image('player-ship', 'images/player-ship.png')
        @game.load.image('enemy', 'images/enemy.png')
        @game.load.spritesheet('planets', 'images/planets.png', 64, 64, 4)

    create: ->
        @game.state.start('Game')


class GameState extends Phaser.State
    create: ->
        @createPlanets()
        @createInputs()
        new PlayerShip(@game, 500, 400)
        new PlayerShip(@game, 505, 400)
        new PlayerShip(@game, 510, 400)

    createInputs: ->
        @inputs = for rowData, row in KEYMAP
            for keyName, col in rowData
                if keyName == ';' then keyName = 'COLON'
                if keyName == ',' then keyName = 'COMMA'
                if keyName == '.' then keyName = 'PERIOD'
                if keyName == "'" then keyName = 'QUOTES'
                if keyName == "/" then keyName = 'QUESTION_MARK'
                key = @game.input.keyboard.addKey(Phaser.Keyboard[keyName])
                key.onDown.add(@handleKeyPress(col, row))

    handleKeyPress: (col, row) ->
        (e) =>
            @planets[row][col].toggle()

    createPlanets: ->
        offset = 100
        spacing = 150
        stagger = 20

        @planets = for rowData, row in KEYMAP
            for keyName, col in rowData
                new Planet(@game,
                    col * spacing + offset + row * stagger
                    row * spacing + offset,
                    keyName
                )

        @planets[1][2].toggle()
        @planets[1][5].toggle()



game = new Phaser.Game(1920, 1080, Phaser.AUTO, 'game-container')
game.state.add('Preload', PreloadState)
game.state.add('Game', GameState)
game.state.start('Preload')
