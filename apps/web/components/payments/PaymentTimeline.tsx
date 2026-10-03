interface PaymentTimelineProps {
  events: Array<{
    title: string;
    date: string;
    description?: string;
  }>;
}

export function PaymentTimeline({
  events,
}: PaymentTimelineProps) {
  return (
    <ol>
      {events.map((event) => (
        <li key={`${event.title}-${event.date}`}>
          <strong>{event.title}</strong>
          <time>{event.date}</time>
          {event.description && (
            <p>{event.description}</p>
          )}
        </li>
      ))}
    </ol>
  );
}
