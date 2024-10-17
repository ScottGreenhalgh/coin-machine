## Designing the FSM

The task undertaken was to develop a FSM vending machine that featured 4 inputs and a single output. The inputs would produce a signal based on 3 different coin types, along with the ability to cancel the current operation and return to an idled state. The single output would handle the situation where enough coins (25 pence in this instance) were inserted into the machine for a vend to occur. The desired naming convention for the inputs were Insert5, Insert10, Insert20 and Cancel. The output would be labelled Open. I then broke down all the criteria for the machine into a few bullet points to gather an understanding on exactly what the machine is intended to do.

- Vending machine sells product for 25p
- Accepts 5 pence, 10 pence, and 20 pence pieces.
- Overpaying results in no change
- Once 25p threshold is reached the machine will vend
- Cancel button will interrupt current operation and reset the machine
- Once dispensed, return to initial conditions/state.

Looking at the left-hand side of the diagram in coin_fsm.png, the inputs are handled by a mechanical interface that sends a digital signal of 1 depending on the coin inserted, or no signal if no coins are inserted. This signal is passed onto the FSM, the portion that will be developed in Vivado, more on this later. For now, this is just a mystery box until I devise a strategy for the workings. There will be a clock and cancel feature present at this step, making for an important consideration when designing this portion. Lastly on the right side we have the dispenser, again this will likely be handled mechanically in a physical product. Using the diagram, I decided to devise a state transition diagram that would allow this configuration to function.

Looking at the state transition diagram on the right hand side of diagram.png, I tried to handle every possible coin combination, regardless of what state you were in. The idea was to make sure there was always an operation to undertake no matter how many coins the machine had received so far. Expanding on that thought further, we can see the naming convention of the states, idle, 5p, 10p, 15p and 20p. This allows for the state machine to maintain a total count of all the coins that have been inserted up until that point. For example, if Insert5 occurs sequentially twice in a row, we would be placed at the 10p state, named as such since it acts as a tally of all the coins inserted until that point. For simplicity when observing the diagram, I placed all the sequential tallying transitions on the top, while all the transitions that reset to idle, and subsequently vending on the bottom. Using this state transition diagram, I was able to derive a truth table of values. This can be found in truth_table.png.

The data in the truth table was calculated using the state transition diagram previously reviewed. This diagram lists all the possible inputs that could occur and the state where they would occur. It is important to note here that when this table was derived, it was important to acknowledge that only a single coin could be input at any one time. The result of this is only one input can be enabled at any one time, meaning there is only 4 different scenarios to consider per state. The resultant output at Open is then recorded, very important data when we move onto translating this information into VHDL. From here I decided I was ready to build the state machine in Vivado.

To begin with, I had a small issue with premature vending, usually when the next coin should have triggered a vend. After some debug messages were implemented into the design via added reports to the log, listing exactly what state I was located in, along with when Insert5 was set to 1 in the state machine. Initially I had the following:

```
STATE_MEMORY : process (Clock, Cancel)
        begin
        if (Cancel = '0') then
            current_state <= idle;
        elsif (rising_edge(Clock)) then
            current_state <= next_state;
```

After some extensive observations I came to the conclusion that using the rising_edge of the clock signal was the problematic portion of the operations and hastily switched to the falling_edge instead. This was because all of the other operations of the FSM appeared to be operating at the falling_edge of the signal. This issue came to light thanks to the debug messages found below:

```
Time: 15 ns  Iteration: 1  Process: /vending_tb/UUT/STATE_MEMORY  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: insert5
Time: 15 ns  Iteration: 2  Process: /vending_tb/UUT/NEXT_STATE_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: insert5 no vend
Time: 15 ns  Iteration: 2  Process: /vending_tb/UUT/OUTPUT_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: no change
Time: 20 ns  Iteration: 1  Process: /vending_tb/UUT/NEXT_STATE_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: no insert no vend
Time: 20 ns  Iteration: 1  Process: /vending_tb/UUT/OUTPUT_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: fivep
Time: 25 ns  Iteration: 1  Process: /vending_tb/UUT/STATE_MEMORY  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: insert10
Time: 30 ns  Iteration: 1  Process: /vending_tb/UUT/NEXT_STATE_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: insert10 no vend
Time: 30 ns  Iteration: 1  Process: /vending_tb/UUT/OUTPUT_LOGIC  File: E:/Uni/VHDL_Resit/DD_Resit_Y3843788/DD_Resit_Y3843788.srcs/sources_1/new/vending.vhd
Note: fivep
```

Based on the debug messages I had implemented I noted that a few operations were occurring during the same clock cycle. The problematic portion was at the 25ns region and the 30ns region. Here Insert10 was being recorded by the STATE_MEMORY 5ns before NEXT_STATE_LOGIC acknowledged it had occurred. My previously mentioned change fixed the issue, however I thought it was worth noting since it caused discrepancies in the overall operation of the FSM.
Once everything appeared to be operating as intended, I moved onto an extensive way testing the design. The methodology I settled upon revolved around using 5p to test the main functionality of the FSM since the syntax of each coin is identical and therefore would behave identically. This was also a good coin to test as it allows for cycling between each available state and features debug messages previously implemented, dumping vital information to the log, allowing me to observe exactly how it’s behaving at each nano second interval. Alongside this I also threw in some 10p insertions to confirm for sure the working functionality of this portion, and lastly some 20p coins to observe whether overpaying is handled correctly in the FSM. Again, adhering to design criteria, this would result in no change being delivered. During the insertion of my 5p coins, I also threw in a small interrupt via the Cancel input to observe whether it would default back to the idle state. Based on this design, I believe this would cover all possible conditions the FSM would fall under and therefore supply a full test of the constraints of the machine. The output of the FSM can be found under FSM_Output.png.

In the simulation, a few changes had been made to the naming convention when compared to the state transition diagram. The most important change to note above is the change from using the name “Open” when referring to the output. There was an issue with this name since Vivado thought this name was a separate variable and behaved strangely with this name. I decided to change this to “Vend” instead as this is the purpose of that output. Alongside this the states 5p, 10p, 15p and 20p were given different names, to prevent the state name beginning with a number. As a result of this the states are named fivep, tenp, fifteenp and twentyp respectively.

# Designing the Register Bank

During the design process, the supplied diagram (found below) was used as a heavy reference point. While I understood from the script that a creating a functioning decoder wasn’t required, it was mentioned that the behaviour of the decoder was identical to a multiplexer so that’s what the initial target was. As a result, I began the construction of a multiplexer with the provided diagram as a reference point. From here I proceeded to create some AND gate logic since I assumed based on the diagram that if the decoder produced a signal to the desired output and data was ready to be retrieved from the register, a positive signal should be produced at the output. This was however a heavy assumption and wasn’t entirely a guaranteed solution. This decision was based on the square with a triangle notation found on the diagram which represented no known notation I had seen before. Based on this assumption, this was my next targeted development as an AND gate seemed like the most likely logic that was needed here. This data would then forward onto the output assuming the two required inputs were available (decoder output and register output) as per the diagram. This was the fundamental design I was drawn towards and therefore a fair portion of time was invested in devising a structure that would accommodate these two features.

My next course of action was the register logic itself. This was arguably the most important portion of the register bank so again the focus was to create something that resembles what is shown in the diagram. From my understanding a functioning register requires a clock, an enable, the ability to reset and data to be stored. Alongside this an output is needed if the data is pulled. Stringing the whole design together was done in a top level design called register_bank.vhd.

After the first few simulations were conducted, it became apparent that something wasn’t working as intended. After rigorous testing these issues remained. Multiple design changes were made however the logic wouldn’t execute correctly. I’m fairly confident the clock process wasn’t passing to the entire suite of component correctly. I applied a clock signal to the register however I don’t believe it ever left this portion of the circuit. This design oversight was down to my initial intention to create a circuit approximation as similar to the supplied diagram as possible, where no clock signals were listed and therefore there was a heavy disregard to the clock and reset signals and their associated pathing. A few issues popped up during synthesis while development was underway however, I considered this a minor issue at the time. By the time a basic test bench was developed the issue had cemented itself into the design. As of now I’m unsure where the design fell short.
