package com.example.test

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.ContextThemeWrapper
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.text.isDigitsOnly
import java.lang.Integer.parseInt

class MainActivity : AppCompatActivity() {
    companion object {
        private val INPUT_BUTTONS = listOf(
                listOf("1", "2", "3", "C", "CE"),
                listOf("4", "5", "6", "/", "*"),
                listOf("7", "8", "9", "-"),
                listOf("0", ".", "=", "+")
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        addCells(findViewById(R.id.calculator_input_container_line1), 0)
        addCells(findViewById(R.id.calculator_input_container_line2), 1)
        addCells(findViewById(R.id.calculator_input_container_line3), 2)
        addCells(findViewById(R.id.calculator_input_container_line4), 3)
    }

    private fun addCells(linearLayout: LinearLayout, position: Int) {
        for (x in INPUT_BUTTONS[position].indices) {
            linearLayout.addView(
                    TextView(
                            ContextThemeWrapper(this, R.style.CalculatorInputButton)
                    ).apply {
                        text = INPUT_BUTTONS[position][x]
                        setOnClickListener { onCellClicked(this.text.toString()) }
                    },
                    LinearLayout.LayoutParams(
                            0,
                            ViewGroup.LayoutParams.MATCH_PARENT,
                            1f
                    )
            )
        }
    }

    private var input: Int? = null
    private var previousInput: Int? = null
    private var symbol: String? = null
    private var decimal: Boolean? = false

    private fun onCellClicked(value: String) {
        when(value) {
            // QUESTION 1
            "." -> {
                /*if(decimal == true || input.toString().contains('.')) return;
                decimal = true;*/
            }

            // QUESTION 3
            "C" -> {
                updateDisplayContainer(input!!.div(10).toString());
                input = input!!.div(10);
            }
            "CE" -> {
                updateDisplayContainer(0);
                input = 0;
            }
        }
        when {
            value.isNum() -> {
                // QUESTION 1
                /*if(decimal == true) {
                    if(input === null) input = "0.$input".toDouble();
                    else input = "$input.$value".toDouble();
                }else {
                    if(input === null) input = value.toInt()
                    else input = (input.toString() + value).toInt()
                }*/

                if(input === null) input = value.toInt()
                else input = (input.toString() + value).toInt()
                updateDisplayContainer(input!!)
            }
            value == "=" -> onEqualsClicked()
            listOf("/", "*", "-", "+").contains(value) -> onSymbolClicked(value)
        }
    }

    private fun updateDisplayContainer(value: Any) {
        findViewById<TextView>(R.id.calculator_display_container).text = value.toString()
    }

    private fun onSymbolClicked(symbol: String) {
        Log.d("CELL", input.toString())
        this.symbol = symbol
        previousInput = input
        input = null
    }

    private fun onEqualsClicked() {
        if (input == null || previousInput == null || symbol == null) {
            return
        }

        val result: Any? = when (symbol) {
            "+" -> previousInput!! + input!!
            "-" -> previousInput!! - input!!
            "*" -> previousInput!! * input!!
            "/" -> {
                // QUESTION 2
                if(input!! <= 0) {
                    "ERROR"
                }else previousInput!! / input!!
            }
            else -> "ERROR"
        }

        updateDisplayContainer(result!!)

        // QUESTION 4
        input = result as Int?
        previousInput = null
        symbol = null
    }
}

fun String.isNum(): Boolean {
    return length == 1 && isDigitsOnly()
}