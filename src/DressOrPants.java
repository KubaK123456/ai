import CLIPSJNI.Environment;
import CLIPSJNI.PrimitiveValue;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.BreakIterator;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

class DressOrPants implements ActionListener {
    JLabel displayLabel;
    JButton nextButton;
    JButton prevButton;
    JPanel choicesPanel;
    ButtonGroup choicesButtons;
    ResourceBundle autoResources;

    Environment clips;
    boolean isExecuting = false;
    Thread executionThread;

    DressOrPants() {
        try {
            autoResources = ResourceBundle.getBundle("resources.DressOrPantsResources", Locale.getDefault());
        } catch (MissingResourceException mre) {
            mre.printStackTrace();
            return;
        }

        JFrame jfrm = new JFrame(autoResources.getString("DressOrPants"));

        jfrm.getContentPane().setLayout(new GridLayout(3, 1));

        jfrm.setSize(350, 200);

        jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel displayPanel = new JPanel();
        displayLabel = new JLabel();
        displayPanel.add(displayLabel);

        choicesPanel = new JPanel();
        choicesButtons = new ButtonGroup();

        JPanel buttonPanel = new JPanel();

        prevButton = new JButton(autoResources.getString("Prev"));
        prevButton.setActionCommand("Prev");
        buttonPanel.add(prevButton);
        prevButton.addActionListener(this);

        nextButton = new JButton(autoResources.getString("Next"));
        nextButton.setActionCommand("Next");
        buttonPanel.add(nextButton);
        nextButton.addActionListener(this);

        jfrm.getContentPane().add(displayPanel);
        jfrm.getContentPane().add(choicesPanel);
        jfrm.getContentPane().add(buttonPanel);

        clips = new Environment();

        clips.load("dressorpants.clp");

        clips.reset();
        runAuto();

        jfrm.setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DressOrPants::new);
    }

    private void nextUIState() throws Exception {
        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentID + "))";

        PrimitiveValue fv = clips.eval(evalStr).get(0);

        if (fv.getFactSlot("state").toString().equals("final")) {
            nextButton.setActionCommand("Restart");
            nextButton.setText(autoResources.getString("Restart"));
            prevButton.setVisible(true);
        } else if (fv.getFactSlot("state").toString().equals("initial")) {
            nextButton.setActionCommand("Next");
            nextButton.setText(autoResources.getString("Next"));
            prevButton.setVisible(false);
        } else {
            nextButton.setActionCommand("Next");
            nextButton.setText(autoResources.getString("Next"));
            prevButton.setVisible(true);
        }

        choicesPanel.removeAll();
        choicesButtons = new ButtonGroup();

        PrimitiveValue pv = fv.getFactSlot("valid-answers");

        String selected = fv.getFactSlot("response").toString();

        for (int i = 0; i < pv.size(); i++) {
            PrimitiveValue bv = pv.get(i);
            JRadioButton rButton;

            if (bv.toString().equals(selected)) {
                rButton = new JRadioButton(autoResources.getString(bv.toString()), true);
            } else {
                rButton = new JRadioButton(autoResources.getString(bv.toString()), false);
            }

            rButton.setActionCommand(bv.toString());
            choicesPanel.add(rButton);
            choicesButtons.add(rButton);
        }

        choicesPanel.repaint();

        String theText = autoResources.getString(fv.getFactSlot("display").symbolValue());

        wrapLabelText(displayLabel, theText);

        executionThread = null;

        isExecuting = false;
    }

    public void actionPerformed(
            ActionEvent ae) {
        try {
            onActionPerformed(ae);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void runAuto() {
        Runnable runThread =
                () -> {
                    clips.run();

                    SwingUtilities.invokeLater(
                            () -> {
                                try {
                                    nextUIState();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            });
                };

        isExecuting = true;

        executionThread = new Thread(runThread);

        executionThread.start();
    }

    public void onActionPerformed(
            ActionEvent ae) throws Exception {
        if (isExecuting) return;

        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";

        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        if (ae.getActionCommand().equals("Next")) {
            if (choicesButtons.getButtonCount() == 0) {
                clips.assertString("(next " + currentID + ")");
            } else {
                clips.assertString("(next " + currentID + " " +
                        choicesButtons.getSelection().getActionCommand() +
                        ")");
            }

            runAuto();
        } else if (ae.getActionCommand().equals("Restart")) {
            clips.reset();
            runAuto();
        } else if (ae.getActionCommand().equals("Prev")) {
            clips.assertString("(prev " + currentID + ")");
            runAuto();
        }
    }

    private void wrapLabelText(JLabel label, String text) {
        FontMetrics fm = label.getFontMetrics(label.getFont());
        Container container = label.getParent();
        int containerWidth = container.getWidth();
        int textWidth = SwingUtilities.computeStringWidth(fm, text);
        int desiredWidth;

        if (textWidth <= containerWidth) {
            desiredWidth = containerWidth;
        } else {
            int lines = (textWidth + containerWidth) / containerWidth;

            desiredWidth = textWidth / lines;
        }

        BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        StringBuilder trial = new StringBuilder();
        StringBuilder real = new StringBuilder("<html><center>");

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE;
             start = end, end = boundary.next()) {
            String word = text.substring(start, end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm, trial.toString());
            if (trialWidth > containerWidth) {
                trial = new StringBuilder(word);
                real.append("<br>");
                real.append(word);
            } else if (trialWidth > desiredWidth) {
                trial = new StringBuilder();
                real.append(word);
                real.append("<br>");
            } else {
                real.append(word);
            }
        }

        real.append("</html>");

        label.setText(real.toString());
    }
}