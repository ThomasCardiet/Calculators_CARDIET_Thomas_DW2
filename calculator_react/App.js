import Style from './src/Style';
import InputButton from './src/InputButton';

import React, {
    Component
} from 'react';

import {
    View,
    Text,
    AppRegistry
} from 'react-native';

const inputButtons = [
    ['', '', 'C', 'CE'],
    [1, 2, 3, '/'],
    [4, 5, 6, '*'],
    [7, 8, 9, '-'],
    [0, '.', '=', '+'],
];

class ReactCalculator extends Component {

    constructor(props) {
        super(props);

        this.state = {
            previousInputValue: 0,
            inputValue: 0,
            selectedSymbol: null
        }
    }

    render() {
        return (
            <View style={Style.rootContainer}>
                <View style={Style.displayContainer}>
                    <Text style={Style.displayText}>{this.state.inputValue}</Text>
                </View>
                <View style={Style.inputContainer}>
                    {this._renderInputButtons()}
                </View>
            </View>
        )
    }

    _renderInputButtons() {
        let views = [];

        for (var r = 0; r < inputButtons.length; r ++) {
            let row = inputButtons[r];

            let inputRow = [];
            for (var i = 0; i < row.length; i ++) {
                let input = row[i];

                inputRow.push(
                    <InputButton
                        value={input}
                        onPress={this._onInputButtonPressed.bind(this, input)}
                        key={r + "-" + i}/>
                );
            }

            views.push(<View style={Style.inputRow} key={"row-" + r}>{inputRow}</View>)
        }
        return views;
    }

    _onInputButtonPressed(input) {
        if(this.state.inputValue === "erreur") this.state.inputValue = 0;
        switch (typeof input) {
            case 'number':
                let str_input = ""+this.state.inputValue;
                if(str_input.indexOf('.') === str_input.length-1) {
                    return this._handleNumberInput(input, true)
                }
                return this._handleNumberInput(input, false)
            case 'string':
                return this._handleStringInput(input)
        }
    }

    _handleNumberInput(num, decimal) {
        let inputValue = 0;
        if(decimal) {
            inputValue = parseFloat(this.state.inputValue + num)
        }else {
            inputValue = parseFloat((""+this.state.inputValue) + num);
        }

        this.setState({
            inputValue: inputValue
        })
    }

    _handleStringInput(str) {
        switch (str) {
            // QUESTION 1
            case 'C':
                let str_input = ""+this.state.inputValue;
                this.setState({
                    inputValue: str_input.length === 1 ? 0 : parseInt(str_input.substr(0,str_input.length - 1))
                });
                break;
            case 'CE':
                this.setState({
                    previousInputValue: 0,
                    inputValue: 0
                });
                break;

            // QUESTION 2
            case '.':
                if((""+this.state.inputValue).indexOf('.') !== -1) break;
                this.setState({
                    inputValue: this.state.inputValue + '.'
                });
                break;

            case '/':
            case '*':
            case '+':
            case '-':
                this.setState({
                    selectedSymbol: str,
                    previousInputValue: this.state.inputValue,
                    inputValue: 0
                });
                break;
            case '=':
                let symbol = this.state.selectedSymbol,
                    inputValue = this.state.inputValue,
                    previousInputValue = this.state.previousInputValue;

                if (!symbol) {
                    return;
                }

                let result = eval(previousInputValue + symbol + inputValue);

                // QUESTION 3
                if(symbol === "/" && inputValue === 0) {
                    result = "erreur";
                }
                this.setState({
                    previousInputValue: 0,
                    inputValue: result,
                    selectedSymbol: null
                });
                break;
        }
    }
}

export default ReactCalculator