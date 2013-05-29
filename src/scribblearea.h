#ifndef SCRIBBLEAREA_H
#define SCRIBBLEAREA_H

#include <QDeclarativeItem>
#include <QGraphicsSceneMouseEvent>

class ScribbleArea : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(qreal penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(bool modified READ modified WRITE setModified NOTIFY modifiedChanged)

public:
    explicit ScribbleArea(QDeclarativeItem *parent = 0);

    Q_INVOKABLE void clear();
    Q_INVOKABLE bool open(const QString &fileName);
    Q_INVOKABLE bool save(const QString &fileName);

signals:
    void colorChanged();
    void penWidthChanged();
    void modifiedChanged();

protected:
    void mousePressEvent(QGraphicsSceneMouseEvent *event);
    void mouseMoveEvent(QGraphicsSceneMouseEvent *event);
    void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *);
    void resizeImage(QImage *image, const QSize &newSize);

private:
    QColor m_color;
    QColor color() const { return m_color; }
    void setColor(const QColor &color){ if (m_color!=color){m_color = color;emit colorChanged();} }

    qreal m_penWidth;
    qreal penWidth() const { return m_penWidth; }
    void setPenWidth(const qreal &penWidth){ if (m_penWidth!=penWidth){m_penWidth = penWidth; emit penWidthChanged();} }

    bool m_modified;
    bool modified() const { return m_modified; }
    void setModified( const bool &modified ){ if(m_modified!=modified){ m_modified = modified; emit modifiedChanged(); } }

    QImage m_image;
    QPointF lastPoint, endPoint;
    void drawLine();
};

#endif // SCRIBBLEAREA_H
