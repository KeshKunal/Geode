package com.example.geode
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class BlockedActivity : AppCompatActivity() {
    // This 'onCreate' function runs when the screen is created.
    // It's similar to the 'initState' method in a Flutter widget.
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create a simple text view programmatically.
        val textView = TextView(this)

        // Get the name of the blocked item that our Accessibility Service sent.
        val item = intent.getStringExtra("BLOCKED_ITEM")

        // Set the text to display the message.
        textView.text = "Access to '$item' is blocked by Geode."
        textView.textSize = 24f
        textView.gravity = android.view.Gravity.CENTER // Center the text on screen

        // This displays the text view on the screen.
        // It's like returning a widget in Flutter's 'build' method.
        setContentView(textView)
    }
}