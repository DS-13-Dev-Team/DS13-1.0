import { T0C } from '../constants';
import { round } from 'common/math';
import { useBackend } from "../backend";
import { Button, Knob, Section, LabeledControls, LabeledList } from "../components";
import { Window } from "../layouts";

export const SpaceHeater = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    temp,
    minTemp,
    maxTemp,
    cell,
    power,
  } = data;

  return (
    <Window
      width={300}
      height={250}
      resizable>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Target Temperature">
              {temp} K ({round(temp - T0C, 2)}&deg; C)
            </LabeledList.Item>
            <LabeledList.Item label="Current Charge">
              {power}% {!cell && "(No Cell Inserted)"}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Controls">
          <LabeledControls>
            <LabeledControls.Item label="Thermostat">
              <Knob
                animated
                value={round(temp - T0C, 2)}
                minValue={minTemp}
                maxValue={maxTemp}
                unit="C"
                onChange={(e, val) => act("temp", { newtemp: val + T0C })} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Cell">
              {cell ? (
                <Button
                  icon="eject"
                  content="Eject Cell"
                  onClick={() => act("cellremove")} />
              ) : (
                <Button
                  icon="car-battery"
                  content="Insert Cell"
                  onClick={() => act("cellinstall")} />
              )}
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
