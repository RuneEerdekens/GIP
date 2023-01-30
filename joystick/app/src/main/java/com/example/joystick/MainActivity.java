package com.example.joystick;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import java.text.DecimalFormat;

public class MainActivity extends AppCompatActivity {

    private ImageView handle;
    private ImageView base;
    private TextView XText;
    private TextView YText;
    private View View;

    private boolean canMove = false;

    private static final DecimalFormat df = new DecimalFormat("0.00");


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        handle = (ImageView) findViewById(R.id.handle);
        base = (ImageView) findViewById(R.id.base);
        XText = (TextView) findViewById(R.id.XCordID);
        YText = (TextView) findViewById(R.id.YCordID);
        View = (View) findViewById(R.id.viewID);

        View.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

                float centerX = base.getX() + (base.getWidth() / 2f) - (handle.getWidth() / 2f);
                float centerY = base.getY() + (base.getHeight() / 2f) - (handle.getHeight() / 2f);
                float radius = base.getWidth() / 2f;


                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        if(event.getY() < 400){
                            canMove = false;
                        }else{
                            canMove = true;
                        }
                        break;


                    case MotionEvent.ACTION_MOVE:
                        if(!canMove){break;}

                        // Update the position of the handle
                        float x = event.getX() - handle.getWidth() / 2f;
                        float y = event.getY() - handle.getHeight() / 2f;

                        float X_Val = (handle.getX() - centerX) / radius;
                        float Y_Val = (handle.getY() - centerY) / radius;


                        // Calculate the distance between the center of the base and the handle
                        float distance = (float) Math.sqrt(Math.pow(centerX - x, 2) + Math.pow(centerY - y, 2));

                        // If the distance exceeds the radius, clamp the handle to the circular edge of the base
                        if (distance > radius) {
                            float angle = (float) Math.atan2(centerY - y, centerX - x);
                            x = centerX - (float) Math.cos(angle) * radius;
                            y = centerY - (float) Math.sin(angle) * radius;
                        }

                        XText.setText("X: " + df.format(X_Val));
                        YText.setText("Y: " + df.format(Y_Val));

                        handle.setX(x);
                        handle.setY(y);
                        break;
                    case MotionEvent.ACTION_UP:
                        // Reset the position of the handle to the center of the base
                        handle.setX(centerX);
                        handle.setY(centerY);

                        XText.setText("X: 0");
                        YText.setText("Y: 0");
                        break;
                }
                return true;
            }

        });
    }
}







